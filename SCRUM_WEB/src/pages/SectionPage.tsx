import type { ReactElement } from 'react'
import NavIcon from '../components/layout/NavIcon'
import type { NavItem } from '../components/layout/navigation'

const SectionPage = ({ section }: { section: NavItem }): ReactElement => (
  <div>
    <h1 className="text-3xl font-semibold tracking-tight sm:text-4xl">{section.label}</h1>
    <p className="mt-2 max-w-xl text-base leading-7 text-slate-600">{section.description}</p>

    <div className="mt-8 flex flex-col items-center rounded-2xl border border-dashed border-slate-300 bg-white/70 px-6 py-16 text-center">
      <span className="grid h-12 w-12 place-items-center rounded-xl bg-violet-100 text-violet-700">
        <NavIcon path={section.icon} className="h-6 w-6" />
      </span>
      <p className="mt-4 text-base font-medium text-slate-900">Esta sección aún no tiene datos conectados</p>
      <p className="mt-1 max-w-sm text-sm leading-6 text-slate-600">
        Cuando se conecte con la API, aquí verás el listado de {section.label.toLowerCase()}.
      </p>
    </div>
  </div>
)

export default SectionPage
