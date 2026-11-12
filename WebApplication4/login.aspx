<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="login.aspx.cs" Inherits="WebApplication4.login" %>

<!DOCTYPE html>
<html lang="es">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Acceso | UniCampus - Sistema de Gestión Académica</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
            background: linear-gradient(135deg, #0a142f 0%, #0e1b38 60%, #15274d 100%);
            color: #1e293b;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .auth-container {
            width: 100%;
            max-width: 420px;
        }

        .brand-header {
            text-align: center;
            margin-bottom: 24px;
            color: #ffffff;
        }
        .brand-logo-icon {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 52px;
            height: 52px;
            background: rgba(37, 99, 235, 0.2);
            border: 1px solid rgba(59, 130, 246, 0.4);
            border-radius: 14px;
            margin-bottom: 12px;
            color: #60a5fa;
        }
        .brand-title {
            font-size: 24px;
            font-weight: 800;
            letter-spacing: -0.5px;
            color: #ffffff;
            line-height: 1.2;
        }
        .brand-subtitle {
            font-size: 13px;
            color: #94a3b8;
            margin-top: 4px;
            font-weight: 400;
        }

        .auth-card {
            background: #ffffff;
            border-radius: 14px;
            box-shadow: 0 20px 40px -15px rgba(0, 0, 0, 0.35), 0 0 0 1px rgba(255, 255, 255, 0.08);
            padding: 26px 28px;
        }

        .tab-bar {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 6px;
            background: #f1f5f9;
            padding: 4px;
            border-radius: 8px;
            margin-bottom: 20px;
        }
        .tab-btn {
            display: block;
            border: none;
            background: transparent;
            padding: 8px 12px;
            font-size: 12.5px;
            font-weight: 600;
            color: #64748b;
            cursor: pointer;
            border-radius: 6px;
            text-align: center;
            text-decoration: none;
            transition: all 0.15s ease;
        }
        .tab-btn:hover {
            color: #0f172a;
        }
        .tab-btn.active {
            background: #ffffff;
            color: #1d4ed8;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
        }

        .field {
            margin-bottom: 14px;
        }
        .field-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 10px;
        }
        .field label {
            display: block;
            font-size: 12px;
            font-weight: 600;
            color: #334155;
            margin-bottom: 5px;
        }
        .field input, .field select {
            width: 100%;
            padding: 9px 12px;
            font-size: 13.5px;
            border: 1px solid #cbd5e1;
            border-radius: 7px;
            background: #ffffff;
            color: #0f172a;
            outline: none;
            transition: border-color 0.15s, box-shadow 0.15s;
        }
        .field input:focus, .field select:focus {
            border-color: #2563eb;
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.15);
        }

        .btn-submit {
            width: 100%;
            background: #2563eb;
            color: #ffffff;
            border: 1px solid #1d4ed8;
            padding: 10px 14px;
            font-size: 13.5px;
            font-weight: 600;
            border-radius: 7px;
            cursor: pointer;
            margin-top: 8px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            box-shadow: 0 2px 4px rgba(37, 99, 235, 0.25);
            transition: background 0.15s, transform 0.05s;
        }
        .btn-submit:hover {
            background: #1d4ed8;
        }
        .btn-submit:active {
            transform: translateY(1px);
        }

        .msg-error {
            background: #fef2f2;
            border: 1px solid #fecaca;
            color: #991b1b;
            padding: 9px 12px;
            border-radius: 6px;
            font-size: 12.5px;
            margin-bottom: 14px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .msg-ok {
            background: #f0fdf4;
            border: 1px solid #bbf7d0;
            color: #166534;
            padding: 9px 12px;
            border-radius: 6px;
            font-size: 12.5px;
            margin-bottom: 14px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .switch-hint {
            margin-top: 16px;
            padding-top: 12px;
            border-top: 1px solid #e2e8f0;
            text-align: center;
            font-size: 12px;
            color: #64748b;
        }
        .switch-link {
            color: #2563eb;
            font-weight: 600;
            text-decoration: none;
            cursor: pointer;
            background: none;
            border: none;
            padding: 0;
            font-size: 12px;
            margin-left: 4px;
        }
        .switch-link:hover {
            text-decoration: underline;
        }

        .quick-accounts {
            margin-top: 20px;
            background: rgba(255, 255, 255, 0.06);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 10px;
            padding: 12px 14px;
            color: #cbd5e1;
            font-size: 11.5px;
            line-height: 1.5;
        }
        .quick-accounts strong {
            color: #ffffff;
        }
        .quick-pill {
            display: inline-block;
            background: rgba(255, 255, 255, 0.12);
            padding: 2px 7px;
            border-radius: 4px;
            cursor: pointer;
            margin: 2px 2px 2px 0;
            color: #93c5fd;
            text-decoration: none;
        }
        .quick-pill:hover {
            background: rgba(255, 255, 255, 0.22);
            color: #ffffff;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server" defaultbutton="btnIngresar">
        <div class="auth-container">
            <!-- Brand Header -->
            <div class="brand-header">
                <div class="brand-logo-icon">
                    <svg width="30" height="30" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M22 10v6M2 10l10-5 10 5-10 5z"/>
                        <path d="M6 12v5c3 3 9 3 12 0v-5"/>
                    </svg>
                </div>
                <h1 class="brand-title">UniCampus</h1>
                <p class="brand-subtitle">Sistema de Gestión Académica</p>
            </div>

            <div class="auth-card">
                <!-- Mode Tabs using LinkButtons (never hijack Enter key like submit buttons) -->
                <div class="tab-bar">
                    <asp:LinkButton ID="btnTabLogin" runat="server" Text="Iniciar Sesión" CssClass="tab-btn active" CausesValidation="false" OnClick="btnTabLogin_Click" />
                    <asp:LinkButton ID="btnTabRegistro" runat="server" Text="Registrarse" CssClass="tab-btn" CausesValidation="false" OnClick="btnTabRegistro_Click" />
                </div>

                <asp:Label ID="lblMensaje" runat="server" CssClass="msg-error" Visible="false" />
                <asp:Label ID="lblExito" runat="server" CssClass="msg-ok" Visible="false" />

                <!-- PANEL LOGIN (DefaultButton is btnIngresar) -->
                <asp:Panel ID="pnlLogin" runat="server" DefaultButton="btnIngresar">
                    <div class="field">
                        <label for="<%= txtUsuario.ClientID %>">Correo electrónico o ID de usuario</label>
                        <asp:TextBox ID="txtUsuario" runat="server" placeholder="usuario@americana.edu.co" autocomplete="username" />
                    </div>

                    <div class="field">
                        <label for="<%= txtClave.ClientID %>">Contraseña</label>
                        <asp:TextBox ID="txtClave" runat="server" TextMode="Password" placeholder="••••••••" autocomplete="current-password" />
                    </div>

                    <asp:Button ID="btnIngresar" runat="server" Text="Entrar al sistema" CssClass="btn-submit" OnClick="btnIngresar_Click" />

                    <div class="switch-hint">
                        ¿No tienes cuenta registrada?
                        <asp:LinkButton ID="lnkIrARegistro" runat="server" CssClass="switch-link" CausesValidation="false" OnClick="btnTabRegistro_Click">Regístrate aquí</asp:LinkButton>
                    </div>
                </asp:Panel>

                <!-- PANEL REGISTRO (DefaultButton is btnCrearCuenta) -->
                <asp:Panel ID="pnlRegistro" runat="server" Visible="false" DefaultButton="btnCrearCuenta">
                    <div class="field">
                        <label>Nombre completo *</label>
                        <asp:TextBox ID="txtRegNombre" runat="server" placeholder="Ej: María López" MaxLength="100" />
                    </div>

                    <div class="field">
                        <label>Correo institucional *</label>
                        <asp:TextBox ID="txtRegCorreo" runat="server" placeholder="nombre@americana.edu.co" MaxLength="150" />
                    </div>

                    <div class="field-row">
                        <div class="field">
                            <label>Contraseña *</label>
                            <asp:TextBox ID="txtRegClave" runat="server" TextMode="Password" placeholder="Mín. 4 caracteres" MaxLength="100" />
                        </div>
                        <div class="field">
                            <label>Teléfono</label>
                            <asp:TextBox ID="txtRegTelefono" runat="server" placeholder="3001234567" MaxLength="30" />
                        </div>
                    </div>

                    <div class="field-row">
                        <div class="field">
                            <label>Programa *</label>
                            <asp:DropDownList ID="ddlRegPrograma" runat="server">
                                <asp:ListItem Text="Ingeniería de Sistemas" Value="Ingeniería de Sistemas" />
                                <asp:ListItem Text="Ingeniería Industrial" Value="Ingeniería Industrial" />
                                <asp:ListItem Text="Diseño Gráfico" Value="Diseño Gráfico" />
                                <asp:ListItem Text="Administración" Value="Administración" />
                                <asp:ListItem Text="Contaduría Pública" Value="Contaduría Pública" />
                                <asp:ListItem Text="Derecho" Value="Derecho" />
                            </asp:DropDownList>
                        </div>
                        <div class="field">
                            <label>Rol *</label>
                            <asp:DropDownList ID="ddlRegRol" runat="server">
                                <asp:ListItem Text="Estudiante" Value="Estudiante" />
                                <asp:ListItem Text="Docente" Value="Docente" />
                                <asp:ListItem Text="Administrador" Value="Administrador" />
                            </asp:DropDownList>
                        </div>
                    </div>

                    <asp:Button ID="btnCrearCuenta" runat="server" Text="Crear cuenta e ingresar" CssClass="btn-submit" OnClick="btnCrearCuenta_Click" />

                    <div class="switch-hint">
                        ¿Ya tienes una cuenta?
                        <asp:LinkButton ID="lnkIrALogin" runat="server" CssClass="switch-link" CausesValidation="false" OnClick="btnTabLogin_Click">Inicia sesión</asp:LinkButton>
                    </div>
                </asp:Panel>
            </div>

            <!-- Fast-fill helper for quick testing -->
            <div class="quick-accounts">
                <div style="font-weight: 600; margin-bottom: 6px;">Cuentas de prueba rápidas (clic para autocompletar):</div>
                <div>
                    <a href="javascript:void(0);" class="quick-pill" onclick="llenar('admin@unicampus.edu','admin123')">🔑 Admin</a>
                    <a href="javascript:void(0);" class="quick-pill" onclick="llenar('docente@americana.edu.co','docente123')">👨‍🏫 Docente</a>
                    <a href="javascript:void(0);" class="quick-pill" onclick="llenar('estudiante@americana.edu.co','123456789')">🎓 Estudiante</a>
                </div>
            </div>
        </div>
    </form>

    <script>
        // Explicitly intercept Enter on inputs to ensure proper submission without losing password
        document.addEventListener('DOMContentLoaded', function () {
            var txtUser = document.getElementById('<%= txtUsuario.ClientID %>');
            var txtPass = document.getElementById('<%= txtClave.ClientID %>');
            var btnIngresar = document.getElementById('<%= btnIngresar.ClientID %>');

            function handleEnter(e) {
                if (e.key === 'Enter' || e.keyCode === 13) {
                    e.preventDefault();
                    if (btnIngresar) {
                        btnIngresar.click();
                    }
                    return false;
                }
            }

            if (txtUser) txtUser.addEventListener('keydown', handleEnter);
            if (txtPass) txtPass.addEventListener('keydown', handleEnter);
        });

        function llenar(correo, clave) {
            var u = document.getElementById('<%= txtUsuario.ClientID %>');
            var c = document.getElementById('<%= txtClave.ClientID %>');
            if (u && c) {
                u.value = correo;
                c.value = clave;
                c.focus();
            }
        }
    </script>
</body>
</html>
