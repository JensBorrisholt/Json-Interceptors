unit Json.Interceptors.DemoClasses;
{$HINTS ON}

interface

uses
  Json.Interceptors, REST.JsonReflect, System.UITypes;

type
  TSubscriptionPollingStatus = (Success, Pending, InProgress, Error);

  // Both syntaxes are supported
  [EnumMember('Success, Pending, In Progress, Error')]
  // [EnumMember('Success'), EnumMember('Pending'), EnumMember('In Progress'), EnumMember('Error')]
  TSubscriptionPollingStatusInterceptor = class sealed(TEnumInterceptor<TSubscriptionPollingStatus>)
  end;

  PollingStatusAttribute = class(JsonReflectAttribute)
  public
    constructor Create;
  end;

  TEnumClass = class
  private
    // You can create your own attribute
    [PollingStatus]
    FStatus: TSubscriptionPollingStatus;

    // Or just use the generic one
    [StringHandler(TSubscriptionPollingStatusInterceptor)]
    FStatus2: TSubscriptionPollingStatus;
  public
    property Status: TSubscriptionPollingStatus read FStatus write FStatus;
    property Status2: TSubscriptionPollingStatus read FStatus2 write FStatus2;
  end;

  TEnum = (One, Two, Three);
  TEnumSet = set of TEnum;

  // If you want to use an other seperator, please do so :D
  [SetMembers('One|Two|Three', '|')]
  TEnumSetInterceptor = class(TSetInterceptor<TEnumSet>)
  end;

  TSetClass = class
  private
    [StringsHandler(TEnumSetInterceptor)]
    FEnum: TEnumSet;
  public
    property Enum: TEnumSet read FEnum write FEnum;
  end;

  TColorClass = class
  private
    [StringHandler(TColorInterceptor)]
    FColor: TColor;
  public
    property Color: TColor read FColor write FColor;
  end;

implementation

{ TPollingStatusAttribute }

constructor PollingStatusAttribute.Create;
begin
  inherited Create(ctString, rtString, TSubscriptionPollingStatusInterceptor, nil, True);
end;

end.
