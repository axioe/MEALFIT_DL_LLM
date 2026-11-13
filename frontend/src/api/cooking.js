import { api } from './client.js'
import { createCookingApi } from './cookingRequests.js'

export const cookingApi = createCookingApi(api)
