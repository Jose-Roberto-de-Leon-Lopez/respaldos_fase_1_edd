unit doubleLinkedList;

{$MODE DELPHI}

interface
    type
        TEmailData = record
            id: string;
            remitente: string;
            destinatario: string; 
            estado: string;      // 'NL' = No leído, 'L' = Leído
            programado: Boolean;
            asunto: string;
            fecha: string;
            mensaje: string;
        end;

        TEmailArray = array of TEmailData;

    procedure LDE_C_Insert(id, remitente, destinatario, estado: string; programado: Boolean; 
                          asunto, fecha, mensaje: string);
    function  LDE_C_GenerateDot: string;
    procedure LDE_C_Clear;
    function LDE_C_GetEmailsByRecipient(destinatario: string): TEmailArray;
    function LDE_C_GetEmailById(id: string): TEmailData;
    procedure LDE_C_QuickSortBySubject;
    procedure LDE_C_MarkAsRead(emailId: string);
    function LDE_C_GetUnreadCount(destinatario: string): Integer;

implementation

    uses
        SysUtils, Classes;

    type
        PNode = ^TNode;
        TNode = record
            id: string;
            remitente: string;
            destinatario: string; 
            estado: string;
            programado: Boolean;
            asunto: string;
            fecha: string;
            mensaje: string;
            Next: PNode;
            Prev: PNode;
        end;

    var
        Head: PNode = nil;
        Tail: PNode = nil;

    function EscapeDotString(const S: string): string;
    var
        Res: string;
        i: Integer;
    begin
        Res := '';
        for i := 1 to Length(S) do
        begin
            case S[i] of
                '"': Res := Res + '\"';
                '\': Res := Res + '\\';
                '|': Res := Res + '\|';
                '{': Res := Res + '\{';
                '}': Res := Res + '\}';
                #10: Res := Res + '\n';
                #13: Res := Res + '\n';
            else
                Res := Res + S[i];
            end;
        end;
        Result := Res;
    end;

    procedure LDE_C_Insert(id, remitente, destinatario, estado: string; programado: Boolean; 
                          asunto, fecha, mensaje: string);
    var
        NewNode: PNode;
    begin
        New(NewNode);
        NewNode^.id := Trim(id);
        NewNode^.remitente := Trim(remitente);
        NewNode^.destinatario := Trim(destinatario);
        NewNode^.estado := Trim(estado);
        NewNode^.programado := programado;
        NewNode^.asunto := Trim(asunto);
        NewNode^.fecha := Trim(fecha);
        NewNode^.mensaje := Trim(mensaje);
        NewNode^.Next := nil;
        NewNode^.Prev := nil;

        if Head = nil then
        begin
            Head := NewNode;
            Tail := NewNode;
        end
        else
        begin
            Tail^.Next := NewNode;
            NewNode^.Prev := Tail;
            Tail := NewNode;
        end;
    end;

    procedure LDE_C_Clear;
    var
        Current, Temp: PNode;
    begin
        Current := Head;
        while Current <> nil do
        begin
            Temp := Current;
            Current := Current^.Next;
            Dispose(Temp);
        end;
        Head := nil;
        Tail := nil;
    end;

    function LDE_C_GenerateDot: string;
    var
        SL: TStringList;
        Current: PNode;
        Counter: Integer;
        NodeName, NextName: string;
        ResultText: string;
    begin
        SL := TStringList.Create;

        SL.Add('digraph ListaDoble {');
        SL.Add('  rankdir=LR;');
        SL.Add('  nodesep=0.5;');
        SL.Add('');
        SL.Add('  subgraph cluster_0 {');
        SL.Add('    label="Lista doblemente enlazada de correos";');
        SL.Add('    fontsize=14;');
        SL.Add('    color=black;');
        SL.Add('    style=filled;');
        SL.Add('    fillcolor=white;');
        SL.Add('    node [shape=record, style=filled, fillcolor=lightyellow];');
        SL.Add('');

        if Head = nil then
            SL.Add('    null [label="VACÍA", shape=plaintext];')
        else
        begin
            Counter := 0;
            Current := Head;
            while Current <> nil do
            begin
                NodeName := Format('nodo%d', [Counter]);
                SL.Add(Format('    %s [label="{%s | %s | %s | %s}"];',
                    [NodeName,
                    EscapeDotString(Current^.asunto),
                    EscapeDotString(Current^.remitente),
                    EscapeDotString(Current^.fecha),
                    EscapeDotString(Current^.estado)]));

                if Current^.Next <> nil then
                begin
                    NextName := Format('nodo%d', [Counter + 1]);
                    SL.Add(Format('    %s -> %s;', [NodeName, NextName]));
                    SL.Add(Format('    %s -> %s;', [NextName, NodeName]));
                end;

                Inc(Counter);
                Current := Current^.Next;
            end;
        end;

        SL.Add('  }');
        SL.Add('}');

        ResultText := SL.Text;
        SL.Free;

        Result := ResultText;
    end;

    function LDE_C_GetEmailsByRecipient(destinatario: string): TEmailArray;
    var
        Current: PNode;
        Emails: TEmailArray;
        Count: Integer;
    begin
        Count := 0;
        Current := Head;
        SetLength(Emails, 0); 

        while Current <> nil do
        begin
            // Buscar correos donde el DESTINATARIO sea el usuario actual
            if Current^.destinatario = destinatario then
            begin
                SetLength(Emails, Count + 1);
                Emails[Count].id := Current^.id;
                Emails[Count].remitente := Current^.remitente;
                Emails[Count].destinatario := Current^.destinatario;  // ← AÑADIDO
                Emails[Count].estado := Current^.estado;
                Emails[Count].programado := Current^.programado;
                Emails[Count].asunto := Current^.asunto;
                Emails[Count].fecha := Current^.fecha;
                Emails[Count].mensaje := Current^.mensaje;
                Inc(Count);
            end;
            Current := Current^.Next;
        end;

        Result := Emails;
    end;

    function LDE_C_GetEmailById(id: string): TEmailData;
    var
        Current: PNode;
        Email: TEmailData;
    begin
        // Inicializar con valores por defecto
        Email.id := '';
        Email.remitente := '';
        Email.destinatario := '';
        Email.estado := 'NL';
        Email.programado := False;
        Email.asunto := '';
        Email.fecha := '';
        Email.mensaje := '';

        Current := Head;
        while Current <> nil do
        begin
            if SameText(Current^.id, id) then
            begin
                Email.id := Current^.id;
                Email.remitente := Current^.remitente;
                Email.destinatario := Current^.destinatario;
                Email.estado := Current^.estado;
                Email.programado := Current^.programado;
                Email.asunto := Current^.asunto;
                Email.fecha := Current^.fecha;
                Email.mensaje := Current^.mensaje;
                Break;
            end;
            Current := Current^.Next;
        end;

        Result := Email;
    end;

    procedure LDE_C_QuickSortBySubject;
    type
        PNodeArray = array of PNode;

        procedure QuickSort(var Arr: PNodeArray; Low, High: Integer);
        var
            i, j: Integer;
            Pivot, Temp: PNode;
        begin
            i := Low;
            j := High;
            Pivot := Arr[(Low + High) div 2];

            repeat
                while CompareText(Arr[i]^.asunto, Pivot^.asunto) < 0 do Inc(i);
                while CompareText(Arr[j]^.asunto, Pivot^.asunto) > 0 do Dec(j);

                if i <= j then
                begin
                    Temp := Arr[i];
                    Arr[i] := Arr[j];
                    Arr[j] := Temp;
                    Inc(i);
                    Dec(j);
                end;
            until i > j;

            if Low < j then QuickSort(Arr, Low, j);
            if i < High then QuickSort(Arr, i, High);
        end;

    var
        Arr: PNodeArray;
        Current: PNode;
        i: Integer;
    begin
        // Contar nodos
        Current := Head;
        i := 0;
        while Current <> nil do
        begin
            Inc(i);
            Current := Current^.Next;
        end;

        if i < 2 then Exit;

        // Crear arreglo con punteros a nodos
        SetLength(Arr, i);
        Current := Head;
        for i := 0 to High(Arr) do
        begin
            Arr[i] := Current;
            Current := Current^.Next;
        end;

        // Ordenar por asunto
        QuickSort(Arr, 0, High(Arr));

        // Reconstruir lista
        Head := Arr[0];
        Head^.Prev := nil;
        for i := 0 to High(Arr)-1 do
        begin
            Arr[i]^.Next := Arr[i+1];
            Arr[i+1]^.Prev := Arr[i];
        end;
        Tail := Arr[High(Arr)];
        Tail^.Next := nil;
    end;

    procedure LDE_C_MarkAsRead(emailId: string);
    var
        Current: PNode;
    begin
        Current := Head;
        while Current <> nil do
        begin
            if Current^.id = emailId then
            begin
                Current^.estado := 'L';
                Exit;
            end;
            Current := Current^.Next;
        end;
    end;

    function LDE_C_GetUnreadCount(destinatario: string): Integer;
    var
        Current: PNode;
        Count: Integer;
    begin
        Count := 0;
        Current := Head;
        while Current <> nil do
        begin
            if (Current^.remitente = destinatario) and (Current^.estado = 'NL') then
                Inc(Count);
            Current := Current^.Next;
        end;
        Result := Count;
    end;

end.