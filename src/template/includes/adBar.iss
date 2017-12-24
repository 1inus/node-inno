var 
	adImage1: HWND;
	adLeft:Integer;
	timeLabel:TLabel;
procedure initAdBar();
var
  HoverTimerCallback: LongWord;
begin
	adLeft:=0;

	timeLabel:=TLabel.Create(WizardForm);
	with timeLabel do begin
		Alignment:=taCenter;
		AutoSize:=false;
		Parent:=WizardForm;
		Left := 0;
		Top := 0;
		Width := 100;
		height := 100;
		Caption:='0%';
		Font.Style := [fsBold];
		Font.Size:= 18;
		Transparent:=true;
	end;

	if {{ui.simpleAdBar.show}} then begin
		{{each ui.simpleAdBar.images as image index}}
		{{if image}} ExtractTemporaryFile('{{image}}') {{/if}}
		{{/each}}

		//window background
		adImage1:=ImgLoad(WizardForm.Handle, ExpandConstant('{tmp}\ad1.png'), {{ui.simpleAdBar.left}}, {{ui.simpleAdBar.top}}, {{ui.simpleAdBar.width}}, {{ui.simpleAdBar.height}}, True, True);
	end;
end;