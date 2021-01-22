interface IHttpRequest
{
    procedure Execute(var Response: HttpResponseMessage): Boolean;
}
