codeunit 50101 "Http Management"
{
    local procedure IsSuccessfulRequest(TransportOK: Boolean; Response: HttpResponseMessage) Success: Boolean
    begin
        Success := TransportOK and Response.IsSuccessStatusCode();

        // TODO: log the details about the request:
        // - who
        // - when
        // - what URL
        // - success status
        // - error
        // - ...
    end;

    procedure Execute(Request: Interface IHttpRequest) Success: Boolean
    var
        Response: HttpResponseMessage;
    begin
        // TODO: perform pre-invocation checks
        // - validate permissions
        // - validate URL
        // - ...

        Success := IsSuccessfulRequest(Request.Execute(Response), Response);
    end;
}
