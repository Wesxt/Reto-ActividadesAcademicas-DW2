<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="crud.aspx.cs" Inherits="WebApplication4.crud" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>Panel de Registros</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="~/Content/stylesheet1.css" rel="stylesheet" type="text/css" runat="server" />
</head>
<body class="bg-light p-4">
    <!-- Se previene que la tecla Enter envíe el formulario involuntariamente en inputs -->
    <form id="form1" runat="server" onkeydown="if(event.key === 'Enter' && event.target.tagName === 'INPUT') { event.preventDefault(); return false; }">
        <div class="container-fluid">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h2 class="mb-0">Registros de Participación</h2>
                <div class="d-flex gap-2">
                    <a href="FormularioWeb.aspx" class="btn btn-primary btn-sm">+ Nuevo Registro</a>
                    <!-- Cambiado a LinkButton para que NO sea el botón de envío predeterminado -->
                    <asp:LinkButton ID="btnCerrarSesion" runat="server" CssClass="btn btn-outline-danger btn-sm" OnClick="btnCerrarSesion_Click">
                        Cerrar Sesión
                    </asp:LinkButton>
                </div>
            </div>

            <asp:Label ID="lblMensaje" runat="server" CssClass="alert alert-info py-2 d-block" Visible="false"></asp:Label>

            <div class="table-responsive bg-white shadow-sm rounded p-3">
                <asp:GridView ID="gvRegistros" runat="server" AutoGenerateColumns="False" 
                    DataKeyNames="numero" 
                    CssClass="table table-bordered table-striped table-hover align-middle mb-0"
                    OnRowEditing="gvRegistros_RowEditing" 
                    OnRowCancelingEdit="gvRegistros_RowCancelingEdit" 
                    OnRowUpdating="gvRegistros_RowUpdating" 
                    OnRowDeleting="gvRegistros_RowDeleting">
                    <Columns>
                        <asp:BoundField DataField="numero" HeaderText="#" ReadOnly="True" />
                        <asp:BoundField DataField="id_estudiante" HeaderText="ID Estudiante" ReadOnly="True" />
                        <asp:BoundField DataField="EstudianteNombre" HeaderText="Estudiante" ReadOnly="True" />
                        <asp:BoundField DataField="Programa" HeaderText="Programa" ReadOnly="True" />
                        <asp:BoundField DataField="Semestre" HeaderText="Semestre" ReadOnly="True" />
                        <asp:BoundField DataField="Tipo_participacion" HeaderText="Participación" ReadOnly="True" />
                        <asp:BoundField DataField="Tema" HeaderText="Tema" ReadOnly="True" />
                        <asp:BoundField DataField="Jornada" HeaderText="Jornada" ReadOnly="True" />
                        
                        <asp:BoundField DataField="comentario" HeaderText="Comentario" ControlStyle-CssClass="form-control form-control-sm" />
                        
                        <asp:CommandField ShowEditButton="True" ShowDeleteButton="True" 
                            ButtonType="Button"
                            EditText="Editar" UpdateText="Actualizar" CancelText="Cancelar" DeleteText="Eliminar"
                            ControlStyle-CssClass="btn btn-sm btn-outline-primary mx-1" />
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </form>
</body>
</html>