table 50101 "Weather Forecast"
{
    Caption = 'Weather Forecast';
    DataClassification = CustomerContent;
    TableType = Temporary;

    fields
    {
        field(1; ID; BigInteger)
        {
            Caption = 'ID';
        }
        field(2; Date; Date)
        {
            Caption = 'Date';
        }
        field(3; Description; Text[30])
        {
            Caption = 'Description';
        }
        field(4; "Min. Temperature"; Decimal)
        {
            Caption = 'Min. Temperature';
        }
        field(5; "Max. Temperature"; Decimal)
        {
            Caption = 'Max. Temperature';
        }
    }

    keys
    {
        key(Primary; ID) { }
        key(Date; Date) { }
    }
}
