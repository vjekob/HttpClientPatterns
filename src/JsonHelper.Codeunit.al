codeunit 50100 "Json Helper"
{
    procedure GetToken(JObject: JsonObject; Property: Text) Token: JsonToken;
    begin
        JObject.Get(Property, Token);
    end;

    procedure GetTokenValue(JObject: JsonObject; Property: Text): JsonValue;
    var
        Token: JsonToken;
    begin
        JObject.Get(Property, Token);
        exit(Token.AsValue());
    end;
}
