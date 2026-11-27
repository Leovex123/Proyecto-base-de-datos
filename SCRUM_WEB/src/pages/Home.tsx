import type { ReactElement } from 'react'
import { Link } from 'react-router-dom'
import NavIcon from '../components/layout/NavIcon'
import { NAV_ITEMS } from '../components/layout/navigation'
import { getCurrentUserName } from '../services/authService'

const Home = (): ReactElement => {
  const userName = getCurrentUserName()
  const sections = NAV_ITEMS.filter((item) => item.path !== '/home')

  return (
    <div>
      <h1 className="text-3xl font-semibold tracking-tight sm:text-4xl">
        {userName ? `Hola, ${userName}` : 'Hola'}
      </h1>
      <p className="mt-2 max-w-xl text-base leading-7 text-slate-600">
        Elige una sección para continuar con el trabajo de tu equipo.
      </p>

      <ul className="mt-8 grid gap-4 sm:grid-cols-2 xl:grid-cols-3">
        {sections.map((item) => (
          <li key={item.path}>
            <Link
              to={item.path}
              className="flex h-full gap-4 rounded-2xl border border-slate-200 bg-white/90 p-5 transition hover:border-violet-300 hover:shadow-lg hover:shadow-violet-200/40 focus:outline-none focus-visible:ring-4 focus-visible:ring-violet-500/20"
            >
              <span className="grid h-11 w-11 shrink-0 place-items-center rounded-xl bg-violet-100 text-violet-700">
                <NavIcon path={item.icon} />
              </span>
              <span>
                <span className="block text-base font-semibold text-slate-900">{item.label}</span>
                <span className="mt-1 block text-sm leading-6 text-slate-600">{item.description}</span>
              </span>
            </Link>
          </li>
        ))}
      </ul>
    </div>
  )
}

export default Home
