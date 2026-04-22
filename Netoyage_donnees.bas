Attribute VB_Name = "Module1"
Sub Netoyage_Données()

    Dim cell As Range
    Dim lastRow As Long
    Dim i As Long
    Dim rngDate As Range
    Dim rngEditeur As Range
    Dim txt As String

    '-------------------------------------------------------------------------
    ' FORMATS NUMÉRIQUES
    ' Colonnes vraiment numériques uniquement : A(X), B(Y), C(OBJECTID), I(id_arbre),
    ' J(haut_tot), K(haut_tronc), L(tronc_diam), U(age_estim), W(clc_nbr_diag)
    ' On exclut D, V, X, AA, AF, AH qui sont dates ou texte
    For Each cell In Range("A:C,I:L,U:U,W:W").SpecialCells(xlCellTypeConstants)
        If IsNumeric(cell.Value) Then
            cell.Value = CDbl(cell.Value)
        End If
    Next cell

    ' Affiche avec 4 décimales pour colonnes A et B
    Columns("A:B").NumberFormat = "0.0000"

    ' Met toutes les colonnes texte en format texte
    Range("E:H,M:T,Y:Z,AB:AE,AG:AG,AI:AK").NumberFormat = "@"

    '-------------------------------------------------------------------------
    ' SUPPRESSION DOUBLONS ET VALEURS ABERRANTES

    lastRow = Cells(Rows.Count, "C").End(xlUp).Row

    ' Boucle de bas en haut pour éviter de sauter des lignes après suppression
    For i = lastRow To 2 Step -1

        ' Supprime si cellule vide en colonne C
        If Cells(i, "C").Value = "" Then
            Rows(i).Delete

        ' Supprime si pas de coordonnées X ou Y
        ElseIf Cells(i, "A").Value = "" Or Cells(i, "B").Value = "" Then
            Rows(i).Delete

        ' Supprime si coordonnées X et Y identiques à une autre ligne (doublon géographique)
        ElseIf WorksheetFunction.CountIfs(Range("A:A"), Cells(i, "A").Value, _
                                          Range("B:B"), Cells(i, "B").Value) > 1 Then
            Rows(i).Delete

        ' Supprime si doublon en colonne C (OBJECTID)
        ElseIf WorksheetFunction.CountIf(Range("C:C"), Cells(i, "C").Value) > 1 Then
            Rows(i).Delete

        ' Supprime si doublon en colonne AE (GlobalID)
        ElseIf WorksheetFunction.CountIf(Range("AE:AE"), Cells(i, "AE").Value) > 1 Then
            Rows(i).Delete

        'Verifier l'age de l'arbre
        ElseIf Cells(i, "U").Value > 1000 Then
            Rows(i).Delete

        Else
            ' Valeur aberrante : hauteur totale (J) ne peut pas être < hauteur tronc (K)
            If Cells(i, "J").Value <> "" And Cells(i, "K").Value <> "" Then
                If CDbl(Cells(i, "J").Value) < CDbl(Cells(i, "K").Value) Then
                    Cells(i, "J").ClearContents
                End If
            End If

            ' la date d'abattage doit être plus récente que la date de plantation
            If Cells(i, "S").Value <> "" And Cells(i, "W").Value <> "" Then
                If IsDate(Cells(i, "S").Value) And IsDate(Cells(i, "W").Value) Then
                    If CDate(Cells(i, "W").Value) <= CDate(Cells(i, "S").Value) Then
                        Cells(i, "W").ClearContents
                    End If
                End If
            End If

        End If

    Next i

    '-------------------------------------------------------------------------
    ' DATES : colonnes D(created_date), T(dte_plantation), X(dte_abattage),
    '         AA(last_edited_date), AF(CreationDate), AH(EditDate)

    lastRow = Cells(Rows.Count, "C").End(xlUp).Row  ' Recalcul après suppressions

    Set rngDate = Union(Range("D2:D" & lastRow), Range("T2:T" & lastRow), _
                        Range("X2:X" & lastRow), Range("AA2:AA" & lastRow), _
                        Range("AF2:AF" & lastRow), Range("AH2:AH" & lastRow))

    For Each cell In rngDate
        If IsDate(cell.Value) Then
            cell.Value = Int(CDate(cell.Value))
            cell.NumberFormat = "dd/mm/yyyy"
        End If
    Next cell

    '-------------------------------------------------------------------------
    ' ÉDITEURS : colonnes E(created_user), Z(last_edited_user),
    '            AG(Creator), AI(Editor)

    Set rngEditeur = Union(Range("E2:E" & lastRow), Range("Z2:Z" & lastRow), _
                           Range("AG2:AG" & lastRow), Range("AI2:AI" & lastRow))

    For Each cell In rngEditeur
        If VarType(cell.Value) = vbString And Trim(cell.Value) <> "" Then
            cell.Value = LCase(Replace(cell.Value, " ", "."))
        End If
    Next cell

    '-------------------------------------------------------------------------
    ' COLONNE F : src_geo

    For Each cell In Range("F2:F" & lastRow)
        If VarType(cell.Value) = vbString Then
            If InStr(1, LCase(cell.Value), "ortho", vbTextCompare) > 0 Then
                cell.Value = "Orthophoto"
            ElseIf LCase(Trim(cell.Value)) = "à renseigner" Then
                cell.ClearContents
            End If
        End If
    Next cell

    '-------------------------------------------------------------------------
    ' COLONNE G : clc_quartier

    For Each cell In Range("G2:G" & lastRow)
        If VarType(cell.Value) = vbString And Trim(cell.Value) <> "" Then
            txt = Trim(cell.Value)
            If LCase(Left(txt, 8)) <> "quartier" Then
                txt = "Quartier " & UCase(Left(txt, 1)) & LCase(Mid(txt, 2))
                cell.Value = txt
            End If
        End If
    Next cell

    '-------------------------------------------------------------------------
    ' COLONNE M : fk_arb_etat

    For Each cell In Range("M2:M" & lastRow)
        If VarType(cell.Value) = vbString Then
            Select Case UCase(Trim(cell.Value))
                Case "SUPPRIM�", "NON ESSOUCH�"
                    cell.Value = "ABATTU"
                Case "ESSOUCH�"
                    cell.Value = "ESSOUCHE"
            End Select
        End If
    Next cell

    '-------------------------------------------------------------------------
    ' COLONNES N à R : première lettre majuscule, reste minuscule

    For Each cell In Range("N2:R" & lastRow)
        If VarType(cell.Value) = vbString And Trim(cell.Value) <> "" Then
            cell.Value = UCase(Left(cell.Value, 1)) & LCase(Mid(cell.Value, 2))
        End If
    Next cell

    '-------------------------------------------------------------------------
    ' COLONNE V : fk_prec_estim → conversion en décimal (ex: 5 → 0.5)

    For Each cell In Range("V2:V" & lastRow)
        If IsNumeric(cell.Value) Then
            cell.Value = CDbl(cell.Value) * 0.1
        End If
    Next cell

    '-------------------------------------------------------------------------
    ' COLONNE AB : première lettre majuscule, reste minuscule

    For Each cell In Range("AB2:AB" & lastRow)
        If VarType(cell.Value) = vbString And Trim(cell.Value) <> "" Then
            cell.Value = UCase(Left(cell.Value, 1)) & LCase(Mid(cell.Value, 2))
        End If
    Next cell

    '-------------------------------------------------------------------------
    ' COLONNES AJ et AK : première lettre majuscule, reste minuscule

    For Each cell In Range("AJ2:AK" & lastRow)
        If VarType(cell.Value) = vbString And Trim(cell.Value) <> "" Then
            cell.Value = UCase(Left(cell.Value, 1)) & LCase(Mid(cell.Value, 2))
        End If
    Next cell

    '-------------------------------------------------------------------------

    ' NETTOYAGE DES CELLULES AVEC ESPACES UNIQUEMENT

    Dim rngUsed As Range
    Set rngUsed = Range("A1:AK" & lastRow)

    For Each cell In rngUsed
        If VarType(cell.Value) = vbString Then
            If Trim(cell.Value) = "" Then
                cell.ClearContents
            End If
        End If
    Next cell
    
    '-------------------------------------------------------------------------
    'Traiter bug date dte_plantation
    
    For Each cell In Range("T2:T" & lastRow)
        If VarType(cell.Value) = vbString And Len(cell.Value) > 10 Then
            cell.Value = Left(cell.Value, 10)
        End If
        If IsDate(cell.Value) Then
            cell.Value = CDate(cell.Value)
            cell.NumberFormat = "dd/mm/yyyy"
        End If
    Next cell

    '-------------------------------------------------------------------------

    ' SUPPRESSION colonne I (id_arbre) devenue inutile
    ' À faire EN DERNIER pour ne pas décaler les références de colonnes
    Columns("I:I").Delete

    MsgBox "Nettoyage terminé !", vbInformation

End Sub
