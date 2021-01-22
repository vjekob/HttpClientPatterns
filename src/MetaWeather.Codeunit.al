codeunit 50100 MetaWeather
{
    var
        SearchUrl: Label 'https://www.metaweather.com/api/location/search/?query=%1', Locked = true;
        ForecastUrl: Label 'https://www.metaweather.com/api/location/%1/', Locked = true;

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

    local procedure JsonToLocation(LocationsArray: JsonArray; var TempLocation: Record "Weather Location" temporary)
    var
        JToken: JsonToken;
        LocationObject: JsonObject;
    begin
        TempLocation.Reset();
        TempLocation.DeleteAll();

        foreach JToken in LocationsArray do begin
            LocationObject := JToken.AsObject();
            TempLocation.WOEID := GetTokenValue(LocationObject, 'woeid').AsInteger();
            TempLocation."Location Type" := GetTokenValue(LocationObject, 'location_type').AsText();
            TempLocation.Location := GetTokenValue(LocationObject, 'title').AsText();
            TempLocation.Insert();
        end;
    end;

    local procedure JsonToForecast(Results: JsonObject; var TempForecast: Record "Weather Forecast" temporary)
    var
        ConsolidatedWeather: JsonArray;
        JToken: JsonToken;
        WeatherObject: JsonObject;
    begin
        TempForecast.Reset();
        TempForecast.DeleteAll();

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

    procedure GetLocations(Search: Text; var TempLocation: Record "Weather Location" temporary)
    var
        Client: Codeunit "Http Management";
        Response: HttpResponseMessage;
        Content: Text;
        LocationsArray: JsonArray;
    begin
        if not Client.Get(GetSearchUrl(Search), Response) then
            exit;

        Response.Content.ReadAs(Content);
        LocationsArray.ReadFrom(Content);
        JsonToLocation(LocationsArray, TempLocation);
    end;

    procedure GetForecast(WOEID: Integer; var TempForecast: Record "Weather Forecast" temporary)
    var
        Client: Codeunit "Http Management";
        Response: HttpResponseMessage;
        Content: Text;
        Results: JsonObject;
    begin
        if not Client.Get(GetForecastUrl(WOEID), Response) then
            exit;

        Response.Content.ReadAs(Content);
        Results.ReadFrom(Content);
        JsonToForecast(Results, TempForecast);
    end;
}
