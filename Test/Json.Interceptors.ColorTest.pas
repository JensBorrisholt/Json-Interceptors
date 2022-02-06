unit Json.Interceptors.ColorTest;

interface

uses
  REST.Json, DUnitX.TestFramework,

  Json.Interceptors.DemoClasses;

type

  [TestFixture]
  TColorTest = class
  strict private
  const
    Color_Test_JSON1 = '{"color":"0x000000FF"}';
    Color_Test_JSON2 = '{"color":"$000000FF"}';
    Color_Test_JSON3 = '{"color":"clRed"}';
    Color_Test_JSON4 = '{"color":"Red"}';

  var
    FColorClass: TColorClass;

  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;

    [Test]
    [TestCase('CompareJSON', Color_Test_JSON1, #0)]
    procedure UnMarshal(const CompareJSON: string);

    [Test]
    [TestCase('0x Hex number', Color_Test_JSON1, #0)]
    [TestCase('$ Hex number', Color_Test_JSON2, #0)]
    [TestCase('ClRed test', Color_Test_JSON3, #0)]
    [TestCase('Red test', Color_Test_JSON4, #0)]
    procedure Marshal(const Json: string);
  end;

implementation

uses
  System.UITypes, System.SysUtils;

{ TColorTest }

procedure TColorTest.Marshal(const Json: string);
var
  ColorClass: TColorClass;
begin
  ColorClass := TJson.JsonToObject<TColorClass>(Json);
  try
    Assert.AreEqual(FColorClass.Color, ColorClass.Color);
  finally
    FreeAndNil(ColorClass);
  end;
end;

procedure TColorTest.Setup;
begin
  FColorClass := TColorClass.Create;
  FColorClass.Color := TColors.Red;
end;

procedure TColorTest.TearDown;
begin
  FreeAndNil(FColorClass);
end;

procedure TColorTest.UnMarshal(const CompareJSON: string);
var
  LJson: string;
begin
  LJson := TJson.ObjectToJsonString(FColorClass);
  Assert.AreEqual(LJson, CompareJSON);
end;

initialization

TDUnitX.RegisterTestFixture(TColorTest);

end.
