codeunit 50103 "MetaWeather Forecast" implements IHttpRequest
{
    var
        ForecastUrl: Label 'https://www.metaweather.com/api/location/%1/', Locked = true;
        WOEID: Integer;
        Results: JsonObject;

    procedure ForecastFor(WOEID2: Integer)
    begin
        WOEID := WOEID2;
    end;

    procedure Execute(var Response: HttpResponseMessage): Boolean;
    var
        Client: HttpClient;
        Content: Text;
    begin
        if not Client.Get(StrSubstNo(ForecastUrl, WOEID), Response) then
            exit(false);

        Response.Content.ReadAs(Content);
        Results.ReadFrom(Content);
        exit(true);
    end;

    procedure ReadForecast(var TempForecast: Record "Weather Forecast" temporary)
    var
        ConsolidatedWeather: JsonArray;
        JToken: JsonToken;
        WeatherObject: JsonObject;
        Json: Codeunit "Json Helper";
    begin
        TempForecast.Reset();
        TempForecast.DeleteAll();

        ConsolidatedWeather := Json.GetToken(Results, 'consolidated_weather').AsArray();

        foreach JToken in ConsolidatedWeather do begin
            WeatherObject := JToken.AsObject();
            TempForecast.ID := Json.GetTokenValue(WeatherObject, 'id').AsBigInteger();
            TempForecast.Date := Json.GetTokenValue(WeatherObject, 'applicable_date').AsDate();
            TempForecast.Description := Json.GetTokenValue(WeatherObject, 'weather_state_name').AsText();
            TempForecast."Min. Temperature" := Json.GetTokenValue(WeatherObject, 'min_temp').AsDecimal();
            TempForecast."Max. Temperature" := Json.GetTokenValue(WeatherObject, 'max_temp').AsDecimal();
            TempForecast.Insert();
        end;
    end;
}
