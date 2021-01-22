codeunit 50102 "MetaWeather Search" implements IHttpRequest
{
    var
        SearchUrl: Label 'https://www.metaweather.com/api/location/search/?query=%1', Locked = true;
        LocationsArray: JsonArray;
        SearchTerm: Text;

    procedure Search(SearchTerm2: Text)
    begin
        SearchTerm := SearchTerm2;
    end;

    procedure Execute(var Response: HttpResponseMessage): Boolean
    var
        Client: HttpClient;
        Content: Text;
    begin
        if not Client.Get(StrSubstNo(SearchUrl, SearchTerm), Response) then
            exit(false);

        Response.Content.ReadAs(Content);
        LocationsArray.ReadFrom(Content);
        exit(true);
    end;

    procedure ReadSearchResults(var TempLocation: Record "Weather Location")
    var
        JToken: JsonToken;
        LocationObject: JsonObject;
        Json: Codeunit "Json Helper";
    begin
        TempLocation.Reset();
        TempLocation.DeleteAll();

        foreach JToken in LocationsArray do begin
            LocationObject := JToken.AsObject();
            TempLocation.WOEID := Json.GetTokenValue(LocationObject, 'woeid').AsInteger();
            TempLocation."Location Type" := Json.GetTokenValue(LocationObject, 'location_type').AsText();
            TempLocation.Location := Json.GetTokenValue(LocationObject, 'title').AsText();
            TempLocation.Insert();
        end;
    end;
}
