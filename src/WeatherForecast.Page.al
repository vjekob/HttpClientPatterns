page 50100 "Weather Forecast"
{
    Caption = 'Weather Forecast';
    PageType = ListPlus;
    SourceTable = "Weather Location";
    SourceTableTemporary = true;
    UsageCategory = Tasks;
    ApplicationArea = All;
    DataCaptionFields = Location;

    layout
    {
        area(Content)
        {
            group(SearchGroup)
            {
                Caption = 'Search';

                field(Search; Search)
                {
                    Caption = 'Search';
                    ApplicationArea = All;

                    trigger OnValidate()
                    var
                        MetaWeather: Codeunit MetaWeather;
                    begin
                        MetaWeather.GetLocations(Search, Rec);
                    end;
                }
            }

            group(Locations)
            {
                Caption = 'Locations';

                repeater(Results)
                {
                    field(Location; Rec.Location)
                    {
                        ApplicationArea = All;
                    }
                    field(Type; Rec."Location Type")
                    {
                        ApplicationArea = All;
                    }
                }
            }

            part(Forecast; "Weather Forecast Subpage")
            {
                Caption = 'Forecast';
            }
        }
    }

    var
        Search: Text;

    trigger OnAfterGetCurrRecord()
    begin
        if Rec.WOEID <> 0 then
            CurrPage.Forecast.Page.Update(Rec.WOEID);
    end;
}
