table 50100 "Weather Location"
{
    Caption = 'Location';
    DataClassification = CustomerContent;
    TableType = Temporary;
    DataCaptionFields = Location;

    fields
    {
        field(1; WOEID; Integer)
        {
            Caption = 'WOEID';
        }
        field(2; "Location Type"; Text[30])
        {
            Caption = 'Location Type';
        }
        field(3; Location; Text[80])
        {
            Caption = 'Location';
        }
    }
}
