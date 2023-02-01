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
                    Item01: Record Item;
                    Item02: Record Item;
                    DuplicatesFilter: Text[2048];
                    ItemDescription: Text[100];
                begin
                    DuplicatesFilter := '';
                    ItemDescription := '';
                    Item01.Reset();
                    Item01.SetCurrentKey(Description);
                    Item01.Ascending(true);
                    if Item01.FindSet() then
                        repeat
                            if ItemDescription <> Item01.Description then begin
                                Item02.Reset();
                                Item02.SetRange(Description, Item01.Description);
                                if Item02.Count > 1 then begin
                                    ItemDescription := Item01.Description;
                                    if DuplicatesFilter = '' then
                                        DuplicatesFilter := Item01.Description
                                    else
                                        DuplicatesFilter := DuplicatesFilter + '|' + Item01.Description;
                                end;
                            end;
                        until Item01.Next() = 0;
                    //Message(DuplicatesFilter);
                    Rec.SetFilter(Description, DuplicatesFilter);
                    CurrPage.Update();
                end;
            }
        }
    }
}
