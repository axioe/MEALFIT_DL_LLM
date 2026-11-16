import { today as localToday } from './date.js';

/**
 * Calculates expiration status
 */
export function getExpirationStatus(expirationDate, imminentThresholdDays = 3, referenceDateStr) {
    if (!expirationDate)
        return 'unknown';
    // 기준일이 없으면 한국(로컬) 날짜. toISOString()은 UTC라 오전 9시 전에는 어제가 된다
    const todayStr = referenceDateStr || localToday();
    if (expirationDate < todayStr)
        return 'expired';
    if (expirationDate === todayStr)
        return 'today';
    const today = new Date(todayStr + 'T00:00:00');
    const target = new Date(expirationDate + 'T00:00:00');
    const diffDays = Math.ceil((target.getTime() - today.getTime()) / (1000 * 60 * 60 * 24));
    if (diffDays <= imminentThresholdDays) {
        return 'imminent';
    }
    return 'normal';
}