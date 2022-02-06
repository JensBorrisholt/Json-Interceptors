unit Json.Interceptors.SetTest;

interface

uses
  REST.Json, DUnitX.TestFramework,

  Json.Interceptors.DemoClasses;

type

  [TestFixture]
  TSetTest = class
  strict private
  const
    Set_Test_JSON = '{"enum":["One","Three"]}';

  var
    FSetClass: TSetClass;

  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;

    [Test]
    [TestCase('', Set_Test_JSON, #0)]
    procedure UnMarshal(const aJson: string);

    [Test]
    [TestCase('', Set_Test_JSON, #0)]
    procedure Marshal(const aJson: string);
  end;

implementation

uses
  System.SysUtils;

{ TSetTest }

procedure TSetTest.Marshal(const aJson: string);
var
  SetClass: TSetClass;
begin
  SetClass := TJson.JsonToObject<TSetClass>(aJson);
  try
    Assert.AreEqual(FSetClass.Enum, SetClass.Enum);
  finally
    FreeAndNil(SetClass);
  end;
end;

procedure TSetTest.Setup;
begin
  FSetClass := TSetClass.Create;
  FSetClass.Enum := [TEnum.One, TEnum.Three];
end;

procedure TSetTest.TearDown;
begin
  FreeAndNil(FSetClass);
end;

procedure TSetTest.UnMarshal(const aJson: string);
var
  LJson: string;
begin
  LJson := TJson.ObjectToJsonString(FSetClass);
  Assert.AreEqual(LJson, aJson);
end;

initialization

TDUnitX.RegisterTestFixture(TSetTest);

end.
