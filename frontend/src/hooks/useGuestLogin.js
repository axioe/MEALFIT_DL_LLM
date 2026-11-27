import { createContext, useContext } from 'react'

// 비로그인 화면에서만 로그인 안내를 제공한다. 회원 화면은 원래의 이동과 동작을 사용한다.
export const GuestLoginContext = createContext(null)
export const useGuestLogin = () => useContext(GuestLoginContext)
