codeunit 50100 MetaWeather
{
    var
        SearchUrl: Label 'https://www.metaweather.com//api/location/search/?query=%1', Locked = true;
        ForecastUrl: Label 'https://www.metaweather.com//api/location/%1/', Locked = true;

    local procedure GetSearchUrl(Search: Text): Text;
    begin
        exit(StrSubstNo(SearchUrl, Search));
    end;

    local procedure GetForecastUrl(WOEID: Integer): Text;
    begin
        exit(StrSubstNo(ForecastUrl, WOEID));
    end;

    local procedure GetToken(JObject: JsonObject; Property: Text) Token: JsonToken;
    begin
        JObject.Get(Property, Token);
    end;

    local procedure GetTokenValue(JObject: JsonObject; Property: Text): JsonValue;
    var
        Token: JsonToken;
    begin
        JObject.Get(Property, Token);
        exit(Token.AsValue());
    end;

    procedure GetLocations(Search: Text; var TempLocation: Record "Weather Location" temporary)
    var
        Client: HttpClient;
        Response: HttpResponseMessage;
        Content: Text;
        LocationsArray: JsonArray;
        JToken: JsonToken;
        LocationObject: JsonObject;
    begin
        Client.Get(GetSearchUrl(Search), Response);

        TempLocation.Reset();
        TempLocation.DeleteAll();

        Response.Content.ReadAs(Content);
        LocationsArray.ReadFrom(Content);
        foreach JToken in LocationsArray do begin
            LocationObject := JToken.AsObject();
            TempLocation.WOEID := GetTokenValue(LocationObject, 'woeid').AsInteger();
            TempLocation."Location Type" := GetTokenValue(LocationObject, 'location_type').AsText();
            TempLocation.Location := GetTokenValue(LocationObject, 'title').AsText();
            TempLocation.Insert();
        end;
    end;

    procedure GetForecast(WOEID: Integer; var TempForecast: Record "Weather Forecast" temporary)
    var
        Client: HttpClient;
        Response: HttpResponseMessage;
        Content: Text;
        Results: JsonObject;
        ConsolidatedWeather: JsonArray;
        JToken: JsonToken;
        WeatherObject: JsonObject;
    begin
        Client.Get(GetForecastUrl(WOEID), Response);

        TempForecast.Reset();
        TempForecast.DeleteAll();

        Response.Content.ReadAs(Content);
        Results.ReadFrom(Content);
        ConsolidatedWeather := GetToken(Results, 'consolidated_weather').AsArray();

        foreach JToken in ConsolidatedWeather do begin
            WeatherObject := JToken.AsObject();
            TempForecast.ID := GetTokenValue(WeatherObject, 'id').AsBigInteger();
            TempForecast.Date := GetTokenValue(WeatherObject, 'applicable_date').AsDate();
            TempForecast.Description := GetTokenValue(WeatherObject, 'weather_state_name').AsText();
            TempForecast."Min. Temperature" := GetTokenValue(WeatherObject, 'min_temp').AsDecimal();
            TempForecast."Max. Temperature" := GetTokenValue(WeatherObject, 'max_temp').AsDecimal();
            TempForecast.Insert();
        end;
    end;
}
