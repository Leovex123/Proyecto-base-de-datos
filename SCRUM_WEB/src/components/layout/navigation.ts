export interface NavItem {
  label: string
  path: string
  description: string
  /** Trazo SVG (viewBox 24x24) del icono de la sección */
  icon: string
}

export const NAV_ITEMS: NavItem[] = [
  {
    label: 'Inicio',
    path: '/home',
    description: 'Resumen general y accesos rápidos.',
    icon: 'M3 11l9-8 9 8M5 10v10h5v-6h4v6h5V10',
  },
  {
    label: 'Iniciativas',
    path: '/iniciativas',
    description: 'Objetivos estratégicos que agrupan el trabajo del equipo.',
    icon: 'M5 21V4M5 4h11l-2 4 2 4H5',
  },
  {
    label: 'Épicas',
    path: '/epicas',
    description: 'Bloques grandes de trabajo que salen de una iniciativa.',
    icon: 'M12 3l9 5-9 5-9-5 9-5zM3 13l9 5 9-5',
  },
  {
    label: 'Características',
    path: '/caracteristicas',
    description: 'Funcionalidades que componen cada épica.',
    icon: 'M4 4h7v7H4zM13 4h7v7h-7zM4 13h7v7H4zM13 13h7v7h-7z',
  },
  {
    label: 'Backlog',
    path: '/backlog',
    description: 'Elementos pendientes del producto, ordenados por prioridad.',
    icon: 'M8 6h12M8 12h12M8 18h12M4 6h.01M4 12h.01M4 18h.01',
  },
  {
    label: 'Tareas',
    path: '/tareas',
    description: 'Trabajo asignado, su estado y sus comentarios.',
    icon: 'M9 11l3 3 8-8M20 12v7a2 2 0 01-2 2H6a2 2 0 01-2-2V6a2 2 0 012-2h9',
  },
  {
    label: 'Usuarios',
    path: '/usuarios',
    description: 'Personas con acceso a la plataforma y su rol.',
    icon: 'M16 21v-2a4 4 0 00-4-4H7a4 4 0 00-4 4v2M9.5 11a4 4 0 100-8 4 4 0 000 8zM21 21v-2a4 4 0 00-3-3.9M16 3.1a4 4 0 010 7.8',
  },
]

export const APP_NAME = 'Scrum Planning'
