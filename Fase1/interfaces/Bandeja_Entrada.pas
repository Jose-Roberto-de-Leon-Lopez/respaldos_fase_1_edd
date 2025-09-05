unit Bandeja_Entrada;

interface

procedure MostrarBandejaWindow;

implementation

uses
    gtk2, glib2, gdk2,
    homeUser, doubleLinkedList, variables,
    Detalles_Email, SysUtils; 
var
    bandejaWindow: PGtkWidget;

procedure OnDetailsClick(widget: PGtkWidget; data: gpointer); cdecl;
var
    emailId: string;
begin
    emailId := PChar(data);
    writeln('VIENDO-CORREO: ', emailId);
    Detalles_Email.MostrarDetailsWindow(emailId);  // ← Unit cambiada
end;

procedure OnSortClick(widget: PGtkWidget; data: gpointer); cdecl;
begin
    writeln('ORDENANDO-POR-ASUNTO');
    doubleLinkedList.LDE_C_QuickSortBySubject();
    gtk_widget_destroy(bandejaWindow);
    MostrarBandejaWindow;
end;

procedure OnDeleteClick(widget: PGtkWidget; data: gpointer); cdecl;
var
    emailId: string;
begin
    emailId := PChar(data);
    writeln('ELIMINANDO-CORREO: ', emailId);
    // Aquí luego se integrará con la pila de papelera
    gtk_widget_destroy(bandejaWindow);
    MostrarBandejaWindow;
end;

procedure OnReturnClick(widget: PGtkWidget; data: gpointer); cdecl;
begin
    gtk_widget_destroy(bandejaWindow);
    homeUser.MostrarHomeUser;
end;

procedure MostrarBandejaWindow;
var
    grid, scroll, table: PGtkWidget;
    emails: TEmailArray;
    i, unreadCount: Integer;
    lblEstado, lblAsunto, lblRemitente: PGtkWidget;
    btnVer, btnEliminar, btnOrdenar, btnReturn: PGtkWidget;
    lblTitle: PGtkWidget;
begin
    gtk_init(@argc, @argv);

    // Obtener correos del usuario actual
    emails := LDE_C_GetEmailsByRecipient(variables.current_user_email);
    unreadCount := LDE_C_GetUnreadCount(variables.current_user_email);

    // Crear ventana
    bandejaWindow := gtk_window_new(GTK_WINDOW_TOPLEVEL);
    gtk_window_set_title(GTK_WINDOW(bandejaWindow), 'Bandeja de Entrada');
    gtk_container_set_border_width(GTK_CONTAINER(bandejaWindow), 10);
    gtk_window_set_default_size(GTK_WINDOW(bandejaWindow), 700, 500);

    // Crear tabla principal
    grid := gtk_table_new(4, 1, False);
    gtk_container_add(GTK_CONTAINER(bandejaWindow), grid);

    // Título con cantidad de no leídos
    lblTitle := gtk_label_new(PChar('BANDEJA DE ENTRADA - ' + IntToStr(unreadCount) + ' NO LEÍDOS'));
    gtk_table_attach_defaults(GTK_TABLE(grid), lblTitle, 0, 1, 0, 1);

    // Botón Ordenar
    btnOrdenar := gtk_button_new_with_label('Ordenar por Asunto (A-Z)');
    g_signal_connect(btnOrdenar, 'clicked', G_CALLBACK(@OnSortClick), nil);
    gtk_table_attach_defaults(GTK_TABLE(grid), btnOrdenar, 0, 1, 1, 2);

    // Contenedor con scroll para la tabla
    scroll := gtk_scrolled_window_new(nil, nil);
    gtk_table_attach_defaults(GTK_TABLE(grid), scroll, 0, 1, 2, 3);

    // Crear tabla de correos
    table := gtk_table_new(Length(emails) + 1, 5, False);
    gtk_scrolled_window_add_with_viewport(GTK_SCROLLED_WINDOW(scroll), table);

    // Encabezados de la tabla
    gtk_table_attach_defaults(GTK_TABLE(table), gtk_label_new('ESTADO'), 0, 1, 0, 1);
    gtk_table_attach_defaults(GTK_TABLE(table), gtk_label_new('ASUNTO'), 1, 2, 0, 1);
    gtk_table_attach_defaults(GTK_TABLE(table), gtk_label_new('REMITENTE'), 2, 3, 0, 1);
    gtk_table_attach_defaults(GTK_TABLE(table), gtk_label_new('VER'), 3, 4, 0, 1);
    gtk_table_attach_defaults(GTK_TABLE(table), gtk_label_new('ELIMINAR'), 4, 5, 0, 1);

    // Llenar tabla con los correos
    for i := 0 to High(emails) do
    begin
        // Columna Estado
        if emails[i].estado = 'NL' then
            lblEstado := gtk_label_new('NO LEÍDO')
        else
            lblEstado := gtk_label_new('LEÍDO');
        gtk_table_attach_defaults(GTK_TABLE(table), lblEstado, 0, 1, i+1, i+2);

        // Columna Asunto
        lblAsunto := gtk_label_new(PChar(emails[i].asunto));
        gtk_table_attach_defaults(GTK_TABLE(table), lblAsunto, 1, 2, i+1, i+2);

        // Columna Remitente
        lblRemitente := gtk_label_new(PChar(emails[i].remitente));
        gtk_table_attach_defaults(GTK_TABLE(table), lblRemitente, 2, 3, i+1, i+2);

        // Botón Ver
        btnVer := gtk_button_new_with_label('Ver');
        g_signal_connect(btnVer, 'clicked', G_CALLBACK(@OnDetailsClick), gpointer(PChar(emails[i].id)));
        gtk_table_attach_defaults(GTK_TABLE(table), btnVer, 3, 4, i+1, i+2);

        // Botón Eliminar
        btnEliminar := gtk_button_new_with_label('Eliminar');
        g_signal_connect(btnEliminar, 'clicked', G_CALLBACK(@OnDeleteClick), gpointer(PChar(emails[i].id)));
        gtk_table_attach_defaults(GTK_TABLE(table), btnEliminar, 4, 5, i+1, i+2);
    end;

    // Botón Regresar
    btnReturn := gtk_button_new_with_label('Regresar');
    g_signal_connect(btnReturn, 'clicked', G_CALLBACK(@OnReturnClick), nil);
    gtk_table_attach_defaults(GTK_TABLE(grid), btnReturn, 0, 1, 3, 4);

    // Mostrar todos los elementos
    gtk_widget_show_all(bandejaWindow);

    // Cuando se cierra la ventana, terminar el programa
    g_signal_connect(bandejaWindow, 'destroy', G_CALLBACK(@gtk_main_quit), nil);

    // Iniciar el bucle principal de eventos de GTK
    gtk_main;
end;

end.