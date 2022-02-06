unit Json.Interceptors.EnumTest;

interface

uses
  REST.Json, DUnitX.TestFramework,

  Json.Interceptors.DemoClasses;

type

  [TestFixture]
  TEnumTest = class
  strict private
  const
    Enum_Json = '{"status":"In Progress","status2":"In Progress"}';

  var
    FEnumClass: TEnumClass;

  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;

    [Test]
    [TestCase('', Enum_Json, #0)]
    procedure UnMarshal(const aJSON: string);

    [Test]
    [TestCase('', Enum_Json, #0)]
    procedure Marshal(const aJson: string);
  end;

implementation

uses
  System.SysUtils;

procedure TEnumTest.Marshal(const aJson: string);
var
  EnumClass: TEnumClass;
begin
  EnumClass := TJson.JsonToObject<TEnumClass>(aJson);
  try
    Assert.AreEqual(FEnumClass.Status, EnumClass.Status);
    Assert.AreEqual(FEnumClass.Status2, EnumClass.Status2);
  finally
    FreeAndNil(EnumClass);
  end;
end;

procedure TEnumTest.Setup;
begin
  FEnumClass := TEnumClass.Create;
  FEnumClass.Status := TSubscriptionPollingStatus.InProgress;
  FEnumClass.Status2 := TSubscriptionPollingStatus.InProgress;
end;

procedure TEnumTest.TearDown;
begin
  FreeAndNil(FEnumClass)
end;

procedure TEnumTest.UnMarshal(const aJSON: string);
var
  LJson: string;
begin
  LJson := TJson.ObjectToJsonString(FEnumClass);
  Assert.AreEqual(LJson, aJSON);
end;

initialization

TDUnitX.RegisterTestFixture(TEnumTest);

end.
