function ReadOthers(w1,escape_action,DeckCheck)
if KeyA==1 && DeckCheck==0
    DrawFormattedText(w1,double('�������ѡ����ȴ�������� >>>'),'center','center', 1,[],[],[],2);
    Screen('Flip',w1,[]);
    DeckCheck=1;
    WaitSecs(2);
    Feedback(w1); %�ȴ����˵�һ��ѡ����
    
    if KeyCode(escape_action)
        %Priority(0);
        break
        Screen('CloseAll');
        ShowCursor;
        fclose('all');
        error('experiment aborted by user');
    end
    if DeckCheck  == 1
        break
    end
end