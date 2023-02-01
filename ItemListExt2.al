pageextension 50144 ItemListExt extends "Item List"
{
    actions
    {
        addfirst(processing)
        {
            action(FindDuplicates)
            {
                Caption = 'Find Duplicates';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = FilterLines;
                trigger OnAction()
                var
                    DuplicatesFilter: Text[2048];
                begin
                    DuplicatesFilter := FindDuplicates(Database::Item, 3);
                    //Message(DuplicatesFilter);
                    Rec.SetFilter(Description, DuplicatesFilter);
                    CurrPage.Update();
                end;
            }
        }
    }
    local procedure FindDuplicates(TableID: Integer; FieldID: Integer) DuplicatesFilter: Text[2048]
    var
        RecRef: RecordRef;
        FldRef: FieldRef;
        RecRef2: RecordRef;
        FldRef2: FieldRef;
        FilterText: Text[100];
    begin
        Clear(RecRef);
        Clear(FldRef);
        DuplicatesFilter := '';
        FilterText := '';
        RecRef.Open(TableID);
        FldRef := RecRef.Field(FieldID);
        RecRef.SetView(StrSubstNo('SORTING(%1)', FldRef.Caption));
        RecRef.Ascending(true);
        if RecRef.FindSet() then
            repeat
                if FilterText <> Format(FldRef.Value) then begin
                    RecRef2.Open(TableID);
                    FldRef2 := RecRef2.Field(FieldID);
                    FldRef2.SetFilter(FldRef.Value);
                    if RecRef2.FindSet() then
                        if RecRef2.Count > 1 then begin
                            FilterText := Format(FldRef2.Value);
                            if DuplicatesFilter = '' then
                                DuplicatesFilter := Format(FldRef2.Value)
                            else
                                DuplicatesFilter := DuplicatesFilter + '|' + Format(FldRef2.Value);
                        end;
                    RecRef2.Close();
                end;
            until RecRef.Next() = 0;
    end;
}
