import { api } from './client.js'
import { createQuickRecipesApi } from '../models/quickRecipeRequests.js'

/** 15분 요리 AI 추천 요청 (Spring → Flask) */
export const quickRecipesApi = createQuickRecipesApi(api)
