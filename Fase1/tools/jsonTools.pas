unit jsonTools;

{$mode objfpc}{$H+}

interface

uses
    simpleLinkedList, doubleLinkedList;

function UploadUsersFromJson(const filePath: string): Boolean;
function AddUserToJson(const filePath: string; const id: Integer; const name, email, username, phone, password: string): Boolean;
function SaveEmailToJson(const filePath: string; id, remitente, destinatario, estado: string; programado: Boolean; asunto, fecha, mensaje: string): Boolean;
function LoadEmailsFromJson(const filePath: string): Boolean;

implementation

uses
    Classes, SysUtils, fpjson, jsonparser, variables;

// ---------------------------
// Carga de usuarios desde JSON
// ---------------------------
function UploadUsersFromJson(const filePath: string): Boolean;
var
    jsonData: TJSONData;
    jsonObject: TJSONObject;
    usersArray: TJSONArray;
    userItem: TJSONObject;
    i: Integer;
    fileStream: TFileStream;
begin
    Result := False;

    if not FileExists(filePath) then
    begin
        Writeln('Archivo no encontrado: ', filePath);
        Exit;
    end;

    try
        fileStream := TFileStream.Create(filePath, fmOpenRead);
        try
            jsonData := GetJSON(fileStream);
        finally
            fileStream.Free;
        end;

        jsonObject := TJSONObject(jsonData);
        usersArray := jsonObject.Arrays['usuarios'];

        for i := 0 to usersArray.Count - 1 do
        begin
            userItem := usersArray.Objects[i];

            LSL_U_Insert(
                IntToStr(userItem.Integers['id']),
                userItem.Strings['nombre'],
                userItem.Strings['email'],
                userItem.Strings['usuario'],
                userItem.Strings['telefono'],
                userItem.Strings['password']
            );
        end;

        jsonData.Free;
        Result := True;

    except
        on E: Exception do
        begin
            Writeln('Error leyendo JSON: ', E.Message);
            Result := False;
        end;
    end;
end;

// ---------------------------
// Añadir un usuario al JSON
// ---------------------------
function AddUserToJson(const filePath: string; const id: Integer; const name, email, username, phone, password: string): Boolean;
var
    jsonData: TJSONData = nil;
    jsonObject: TJSONObject = nil;
    usersArray: TJSONArray = nil;
    newUser: TJSONObject;
    fileStream: TFileStream;
    jsonString: TStringList;
begin
    Result := False;

    if FileExists(filePath) then
    begin
        try
            fileStream := TFileStream.Create(filePath, fmOpenRead);
            try
                jsonData := GetJSON(fileStream);
            finally
                fileStream.Free;
            end;

            jsonObject := TJSONObject(jsonData);
            usersArray := jsonObject.Arrays['usuarios'];

        except
            on E: Exception do
            begin
                Writeln('Error leyendo JSON existente: ', E.Message);
                Exit;
            end;
        end;
    end
    else
    begin
        // Si no existe, crear nuevo objeto JSON con array usuarios
        jsonObject := TJSONObject.Create;
        usersArray := TJSONArray.Create;
        jsonObject.Add('usuarios', usersArray);
    end;

    // Crear nuevo usuario
    newUser := TJSONObject.Create;
    newUser.Add('id', id);
    newUser.Add('nombre', name);
    newUser.Add('email', email);
    newUser.Add('usuario', username);
    newUser.Add('telefono', phone);
    newUser.Add('password', password);

    // Añadir nuevo usuario al array
    usersArray.Add(newUser);

    // Guardar JSON actualizado
    jsonString := TStringList.Create;
    try
        jsonString.Text := jsonObject.FormatJSON();
        jsonString.SaveToFile(filePath);
        Result := True;
    finally
        jsonString.Free;
        if Assigned(jsonData) then
            jsonData.Free
        else
            jsonObject.Free;
    end;
end;

// ---------------------------
// Guardar correo en JSON
// ---------------------------
function SaveEmailToJson(const filePath: string; id, remitente, destinatario, estado: string; programado: Boolean; asunto, fecha, mensaje: string): Boolean;
var
    jsonData: TJSONData = nil;
    jsonObject: TJSONObject = nil;
    emailsArray: TJSONArray = nil;
    newEmail: TJSONObject;
    fileStream: TFileStream;
    jsonString: TStringList;
begin
    Result := False;

    if FileExists(filePath) then
    begin
        try
            fileStream := TFileStream.Create(filePath, fmOpenRead);
            try
                jsonData := GetJSON(fileStream);
            finally
                fileStream.Free;
            end;

            jsonObject := TJSONObject(jsonData);
            emailsArray := jsonObject.Arrays['emails'];

        except
            on E: Exception do
            begin
                // Si hay error, crear nuevo JSON
                jsonObject := TJSONObject.Create;
                emailsArray := TJSONArray.Create;
                jsonObject.Add('emails', emailsArray);
            end;
        end;
    end
    else
    begin
        jsonObject := TJSONObject.Create;
        emailsArray := TJSONArray.Create;
        jsonObject.Add('emails', emailsArray);
    end;

    // Crear nuevo correo
    newEmail := TJSONObject.Create;
    newEmail.Add('id', id);
    newEmail.Add('remitente', remitente);
    newEmail.Add('destinatario', destinatario);
    newEmail.Add('estado', estado);
    newEmail.Add('programado', programado);
    newEmail.Add('asunto', asunto);
    newEmail.Add('fecha', fecha);
    newEmail.Add('mensaje', mensaje);

    // Añadir al array
    emailsArray.Add(newEmail);

    // Guardar JSON
    jsonString := TStringList.Create;
    try
        jsonString.Text := jsonObject.FormatJSON();
        jsonString.SaveToFile(filePath);
        Result := True;
    finally
        jsonString.Free;
        if Assigned(jsonData) then
            jsonData.Free
        else
            jsonObject.Free;
    end;
end;

// ---------------------------
// Cargar correos desde JSON
// ---------------------------
function LoadEmailsFromJson(const filePath: string): Boolean;
var
    jsonData: TJSONData;
    jsonObject: TJSONObject;
    emailsArray: TJSONArray;
    emailItem: TJSONObject;
    i: Integer;
    fileStream: TFileStream;
	destinatario: string; 
begin
    Result := False;
    if not FileExists(filePath) then 
    begin
        Writeln('Archivo de emails no encontrado: ', filePath);
        Exit;
    end;

    
    try
        fileStream := TFileStream.Create(filePath, fmOpenRead);
        try
            jsonData := GetJSON(fileStream);
        finally
            fileStream.Free;
        end;

        jsonObject := TJSONObject(jsonData);
        emailsArray := jsonObject.Arrays['emails'];

        Writeln('Cargando correos para: ', variables.current_user_email);
        Writeln('Total de correos en JSON: ', emailsArray.Count);

        for i := 0 to emailsArray.Count - 1 do
        begin
            emailItem := emailsArray.Objects[i];
            destinatario := emailItem.Get('destinatario', '');
            
            Writeln('Correo ', i, ' - Destinatario: ', destinatario);
            
            // Solo cargar correos del usuario actual
            if destinatario = variables.current_user_email then
            begin
                Writeln('-> CORREO PARA USUARIO ACTUAL');
                doubleLinkedList.LDE_C_Insert(
                    emailItem.Get('id', ''),
                    emailItem.Get('remitente', ''),
					emailItem.Get('destinatario', ''),
                    emailItem.Get('estado', 'NL'),
                    emailItem.Get('programado', False),
                    emailItem.Get('asunto', ''),
                    emailItem.Get('fecha', ''),
                    emailItem.Get('mensaje', '')
                );
            end;
        end;

        jsonData.Free;
        Result := True;

    except
        on E: Exception do
        begin
            Writeln('Error leyendo JSON de emails: ', E.Message);
            Result := False;
        end;
    end;
end;

end.