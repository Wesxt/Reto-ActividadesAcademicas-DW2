using System;
using System.Collections.Generic;
using UniCampus.Entities;

namespace UniCampus.DAL
{
    public interface IActividadRepository
    {
        List<ActividadDto> ListarTodas();
        List<ActividadDto> ListarConFiltro(string criterio, string estado, string tipo, DateTime? fecha = null);
        ActividadDto ObtenerPorId(int id);
        int Insertar(ActividadDto actividad);
        bool Actualizar(ActividadDto actividad);
        bool Eliminar(int id);
        EstadisticasDto ObtenerEstadisticas();
    }
}
