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
                    ItemDuplicates: Query ItemDuplicates;
                begin
                    DuplicatesFilter := '';
                    ItemDuplicates.SetFilter(No_, '>1');
                    if ItemDuplicates.Open() then
                        while ItemDuplicates.Read() do begin
                            if DuplicatesFilter = '' then
                                DuplicatesFilter := ItemDuplicates.Description
                            else
                                DuplicatesFilter := DuplicatesFilter + '|' + ItemDuplicates.Description;
                        end;
                    ItemDuplicates.Close();
                    Rec.SetFilter(Description, DuplicatesFilter);
                    CurrPage.Update();
                end;
            }
        }
    }
}
query 50112 ItemDuplicates
{
    QueryType = Normal;
    OrderBy = ascending(Description);
    elements
    {
        dataitem(Item; Item)
        {
            column(Description; Description)
            {
            }
            column(No_)
            {
                Method = Count;
            }
        }
    }
}
