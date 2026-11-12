# UniCampus - Sistema de Registro de Actividades Académicas

## Proyecto Integrador - Desarrollo de Aplicaciones Web II
**Corporación Universitaria Americana**  
**Docente:** Ing. Cindy Fuentes  
**Estudiantes:** Arnold Beleño Zuletta y Jazid Kamell Vásquez

---

## 📌 Descripción del Proyecto
UniCampus es una plataforma web orientada a la gestión, consulta, registro e inscripción de actividades académicas institucionales (talleres, conferencias, seminarios, cursos y encuentros). 

El proyecto fue reestructurado partiendo de un formulario monolítico tradicional hacia una **Arquitectura en Tres Capas desacoplada con el patrón Model-View-Presenter (MVP)** en la capa de presentación, garantizando alta cohesión, bajo acoplamiento, seguridad contra inyecciones SQL mediante ADO.NET parametrizado y control transaccional de cupos.

---

## 🏛️ Arquitectura de la Solución (3 Capas + MVP)

La solución en Visual Studio está compuesta por cuatro proyectos organizados según sus responsabilidades:

1. **`UniCampus.Web` (Capa de Presentación):**
   - Construida con **ASP.NET Web Forms** sobre .NET Framework 4.8.1.
   - Aplica el patrón **Model-View-Presenter (MVP)**:
     - `IActividadesView`: Contrato que define qué datos y eventos necesita la interfaz.
     - `Actividades.aspx` / `Actividades.aspx.cs`: Vista Web Forms que implementa el contrato sin ejecutar SQL ni contener reglas de negocio.
     - `ActividadesPresenter`: Coordina las acciones del usuario, invoca a la BLL y actualiza la vista.

2. **`UniCampus.BLL` (Capa de Lógica de Negocio):**
   - Clases de servicio (`ActividadService`, `InscripcionService`, `UsuarioService`).
   - Valida reglas de negocio: títulos obligatorios, consistencia de fechas (inicio anterior a fin), cupos no negativos (`Cupos >= 0`), bloqueo de estados inválidos y prevención de sobreinscripciones.

3. **`UniCampus.DAL` (Capa de Acceso a Datos):**
   - Repositorios ADO.NET (`ActividadRepository`, `InscripcionRepository`, `UsuarioRepository`).
   - Ejecuta consultas parametrizadas (`SqlParameter`) y transacciones SQL (`SqlTransaction`) para garantizar la integridad referencial y concurrencia de cupos.

4. **`UniCampus.Entities` (Capa Transversal / DTOs):**
   - Clases modelo y DTOs (`ActividadDto`, `UsuarioDto`, `InscripcionDto`, `EstadisticasDto`, `ResultadoOperacion`).

### Flujo de Ejecución de una Operación
```
Usuario interactúa con Actividades.aspx
   ↓ Dispara evento
ActividadesPresenter
   ↓ Llama al servicio con DTO
ActividadService (BLL) — Aplica validaciones de reglas
   ↓ Solicita persistencia
ActividadRepository (DAL) — Ejecuta ADO.NET parametrizado
   ↓ T-SQL
Base de Datos SQL Server (UniCampusDB)
   ↓ Retorna DTO / Resultado
ActividadesPresenter actualiza la vista mediante el contrato IActividadesView
```

---

## 🛠️ Tecnologías Utilizadas
- **Lenguaje:** C# 7.3+
- **Framework:** .NET Framework 4.8.1
- **Motor Web:** ASP.NET Web Forms
- **Base de Datos:** Microsoft SQL Server (Transact-SQL)
- **Acceso a Datos:** ADO.NET puro (`SqlConnection`, `SqlCommand`, `SqlDataReader`, `SqlTransaction`)
- **Estilos:** Bootstrap 5.2.3 + CSS Personalizado (basado fielmente en el mock-up oficial de UniCampus)

---

## 🚀 Instrucciones de Configuración y Ejecución

### 1. Preparar la Base de Datos
1. Abra **SQL Server Management Studio (SSMS)** o use la herramienta de su preferencia.
2. Abra el archivo [`03_BaseDatos.sql`](file:///F:/Proyectos/CRUD%20-%20Arnold%20Beleño%20Zuletta%20(1)/03_BaseDatos.sql) ubicado en la raíz del proyecto.
3. Ejecútelo en su instancia local de SQL Server.  
   *El script creará automáticamente la base de datos `UniCampusDB`, todas las tablas, restricciones y cargará los registros iniciales de prueba.*

### 2. Configurar la Cadena de Conexión
En el archivo `UniCampus.Web/Web.config`, verifique que la cadena de conexión coincida con su servidor local:
```xml
<connectionStrings>
    <add name="UniCampusDb"
         connectionString="Data Source=.;Initial Catalog=UniCampusDB;Integrated Security=True;TrustServerCertificate=True;"
         providerName="System.Data.SqlClient" />
</connectionStrings>
```
*(Por defecto se utiliza autenticación integrada de Windows con la instancia predeterminada `.`)*.

### 3. Abrir y Ejecutar en Visual Studio
1. Abra la solución `UniCampus.sln` en **Visual Studio 2022 o 2026**.
2. Establezca el proyecto `UniCampus.Web` (o `WebApplication4`) como **Proyecto de Inicio** (clic derecho $\rightarrow$ *Establecer como proyecto de inicio*).
3. Presione **F5** o el botón verde **IIS Express**.
4. La aplicación iniciará en la pantalla de autenticación: `https://localhost:44321/login.aspx`.

---

## 👥 Credenciales de Prueba y Matriz de Roles

| Rol | Correo | Contraseña | Capacidades |
| :--- | :--- | :--- | :--- |
| **Administrador** | `admin@unicampus.edu` | `admin123` | Control total, Panel de Control Admin, gestión de usuarios, cambio dinámico de roles, gestión de categorías y moderación global. |
| **Docente** | `docente@americana.edu.co` | `docente123` | Publicar y editar actividades académicas, consultar participantes inscritos y registrar asistencia. |
| **Estudiante** | `estudiante@americana.edu.co` | `123456789` | Consultar actividades, inscribirse con 1 clic (`Inscribirme con mi cuenta`), cancelar inscripción propia y dejar valoraciones y reseñas (1-5★). |

---

## 💾 Exportar Base de Datos SQL Server para Otro Equipo
1. En SSMS: Clic derecho sobre `UniCampusDB` $\rightarrow$ **Tareas** $\rightarrow$ **Generar scripts...**.
2. Seleccionar *"Girar scripts de toda la base de datos"* $\rightarrow$ **Siguiente**.
3. En la pantalla de guardado, hacer clic en **Avanzado**.
4. Cambiar *"Tipos de datos que se van a incluir en el script"* a **"Esquema y datos"**.
5. Guardar como archivo `.sql` y ejecutarlo en el equipo destino.

---

## 📋 Entregables Incluidos
- `01_Informe_Tecnico.md`: Informe técnico con arquitectura, diagramas y matriz de roles.
- `02_Solucion_VisualStudio`: Código fuente estructurado (3 capas + MVP).
- `03_BaseDatos.sql`: Script reproducible de base de datos con cuentas y categorías iniciales.
