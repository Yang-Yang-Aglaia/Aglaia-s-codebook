function Instruction(w1,start_action,escape_action)
% instruction
InstructionText = double('实验即将开始\n请在做出判断后按键做出反应\n请按 Q 键开始实验');
Screen(w1, 'TextSize', 30);
DrawFormattedText(w1,InstructionText,'center','center', 1, [],[],[],2);
Screen('Flip',w1);

start_yes = 0;
%RestrictKeysForKbCheck([start_roleM start_roleN escape_roleM escape_roleN]);
[KeyIsDown, tempt, KeyCode] = KbCheck;
while start_yes == 0
    [KeyIsDown, tempt, KeyCode] = KbCheck;
    if KeyCode(start_action)
        Screen('Flip',w1);
        start_yes = 1;
    elseif KeyCode(escape_action)
        %Priority(0);
        Screen('CloseAll');
        ShowCursor;
        fclose('all');
        error('experiment aborted by user');
    end
    if start_yes == 1;
        break;
    end
end
WaitSecs(1.5);
%RestrictKeysForKbCheck([]);
KeyIsDown = 0;