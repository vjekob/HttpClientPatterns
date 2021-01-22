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
        MetaWeatherForecast: Codeunit "MetaWeather Forecast";
        Http: Codeunit "Http Management";
    begin
        MetaWeatherForecast.ForecastFor(WOEID);
        if Http.Execute(MetaWeatherForecast) then begin
            MetaWeatherForecast.ReadForecast(Rec);
            CurrPage.Update(false);
        end;
    end;
}
