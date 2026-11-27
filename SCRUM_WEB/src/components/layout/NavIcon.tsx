import type { ReactElement } from 'react'

const NavIcon = ({ path, className = 'h-5 w-5' }: { path: string; className?: string }): ReactElement => (
  <svg
    aria-hidden="true"
    className={className}
    fill="none"
    viewBox="0 0 24 24"
    stroke="currentColor"
    strokeWidth="1.8"
    strokeLinecap="round"
    strokeLinejoin="round"
  >
    <path d={path} />
  </svg>
)

export default NavIcon
