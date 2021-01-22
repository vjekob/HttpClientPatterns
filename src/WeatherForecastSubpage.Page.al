page 50101 "Weather Forecast Subpage"
{
    Caption = 'Weather Forecast';
    PageType = ListPart;
    SourceTable = "Weather Forecast";
    SourceTableTemporary = true;
    SourceTableView = sorting(Date);
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Forecast)
            {
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;
                }

                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }

                field(MinTemperature; Rec."Min. Temperature")
                {
                    ApplicationArea = All;
                }

                field(MaxTemperature; Rec."Max. Temperature")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    procedure Update(WOEID: Integer)
    var
        MetaWeather: Codeunit MetaWeather;
    begin
        MetaWeather.GetForecast(WOEID, Rec);
        CurrPage.Update(false);
    end;
}
