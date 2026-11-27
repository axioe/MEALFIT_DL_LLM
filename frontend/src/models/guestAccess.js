const guestScreens = new Map([
  ['/', 'home'], ['/dashboard', 'home'], ['/recommend', 'meals'], ['/workout', 'workout'],
])

export function guestScreenForPath(pathname) {
  return guestScreens.get(pathname.toLowerCase().replace(/\/+$/, '') || '/')
}
