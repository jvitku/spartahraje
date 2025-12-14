// Sparta Praha team ID in SofaScore: 2218
const SPARTA_TEAM_ID = 2218;
const API_BASE_URL = 'https://api.sofascore.com/api/v1';

// Get elements
const loadingEl = document.getElementById('loading');
const resultEl = document.getElementById('result');
const errorEl = document.getElementById('error');
const errorDetailEl = document.getElementById('errorDetail');
const matchInfoEl = document.getElementById('matchInfo');

// Format date to YYYY-MM-DD
function getTodayDate() {
    const today = new Date();
    const year = today.getFullYear();
    const month = String(today.getMonth() + 1).padStart(2, '0');
    const day = String(today.getDate()).padStart(2, '0');
    return `${year}-${month}-${day}`;
}

// Format time from date string
function formatTime(dateString) {
    const date = new Date(dateString);
    return date.toLocaleTimeString('cs-CZ', { hour: '2-digit', minute: '2-digit' });
}

// Check if venue is Letna stadium
function isLetnaStadium(venueName) {
    if (!venueName) return false;
    const letnaNames = ['letná', 'letna', 'generali arena', 'generali česká pojišťovna arena', 'epet arena', 'epet'];
    return letnaNames.some(name => venueName.toLowerCase().includes(name));
}

// Fetch today's matches for Sparta Praha
async function checkTodayMatch() {
    showLoading();

    try {
        const today = getTodayDate();

        // Fetch both last and next events to cover matches that finished today or are upcoming
        const [lastResponse, nextResponse] = await Promise.all([
            fetch(`${API_BASE_URL}/team/${SPARTA_TEAM_ID}/events/last/0`),
            fetch(`${API_BASE_URL}/team/${SPARTA_TEAM_ID}/events/next/0`)
        ]);

        if (!lastResponse.ok || !nextResponse.ok) {
            throw new Error(`HTTP error! last: ${lastResponse.status}, next: ${nextResponse.status}`);
        }

        const [lastData, nextData] = await Promise.all([
            lastResponse.json(),
            nextResponse.json()
        ]);

        // Combine all events
        const allEvents = [...(lastData.events || []), ...(nextData.events || [])];

        // Filter events to find today's match
        const todayMatch = allEvents.find(event => {
            const eventDate = new Date(event.startTimestamp * 1000);
            const eventDateStr = eventDate.toISOString().split('T')[0];
            return eventDateStr === today;
        });

        // Get next 2 upcoming HOME matches at Letná (after today)
        const todayTimestamp = new Date(today).getTime();
        const upcomingMatches = (nextData.events || [])
            .filter(event => {
                const eventTimestamp = event.startTimestamp * 1000;
                const isHome = event.homeTeam.id === SPARTA_TEAM_ID;
                return eventTimestamp > todayTimestamp + (24 * 60 * 60 * 1000) && isHome; // After today and home match
            })
            .slice(0, 2);

        displayResult(todayMatch, upcomingMatches);
    } catch (error) {
        console.error('Error:', error);
        showError(`Chyba při načítání dat: ${error.message}`);
    }
}

// Display loading state
function showLoading() {
    loadingEl.classList.remove('hidden');
    resultEl.classList.add('hidden');
    errorEl.classList.add('hidden');
}

// Display error
function showError(message) {
    loadingEl.classList.add('hidden');
    resultEl.classList.add('hidden');
    errorEl.classList.remove('hidden');
    errorDetailEl.textContent = message;
}

// Format upcoming matches
function formatUpcomingMatches(matches) {
    if (!matches || matches.length === 0) {
        return '';
    }

    const matchesHtml = matches.map(match => {
        const matchDate = new Date(match.startTimestamp * 1000);
        const dateStr = matchDate.toLocaleDateString('cs-CZ', {
            day: '2-digit',
            month: '2-digit',
            year: 'numeric'
        });
        const startTimeStr = matchDate.toLocaleTimeString('cs-CZ', {
            hour: '2-digit',
            minute: '2-digit'
        });

        // Calculate estimated end time (typical match duration: ~2 hours)
        const endDate = new Date(matchDate.getTime() + (2 * 60 * 60 * 1000));
        const endTimeStr = endDate.toLocaleTimeString('cs-CZ', {
            hour: '2-digit',
            minute: '2-digit'
        });

        const opponent = match.awayTeam.name; // Always away team since we filter for home matches

        return `
            <li>
                <strong>${dateStr} ${startTimeStr}-${endTimeStr}</strong> - ${opponent}
            </li>
        `;
    }).join('');

    return `
        <div class="upcoming-matches">
            <h4>Nadcházející zápasy na Letné:</h4>
            <ul>
                ${matchesHtml}
            </ul>
        </div>
    `;
}

// Display result
function displayResult(match, upcomingMatches = []) {
    loadingEl.classList.add('hidden');
    errorEl.classList.add('hidden');
    resultEl.classList.remove('hidden');

    if (!match) {
        // No match today - keep red theme
        document.body.classList.remove('green-theme');
        matchInfoEl.innerHTML = `
            <div class="no-match">
                <div class="emoji">😴</div>
                <h3>Ne, dnes Sparta nehraje</h3>
                <p>Žádný zápas není naplánován na dnešek.</p>
            </div>
        `;
        return;
    }

    const isHome = match.homeTeam.id === SPARTA_TEAM_ID;
    const venueName = match.venue?.stadium?.name || match.venue?.name || '';

    // If Sparta is home, assume it's at Letná (since API doesn't always provide venue info)
    // But if venue name is provided, check it matches Letná stadium names
    const isAtLetna = isHome && (venueName === '' || isLetnaStadium(venueName));

    // Change theme to green if not playing at Letná
    if (!isAtLetna) {
        document.body.classList.add('green-theme');
    } else {
        document.body.classList.remove('green-theme');
    }

    const opponent = isHome ? match.awayTeam : match.homeTeam;

    // Format match time as "14. 12. 2025 18:30-19:33"
    const startDate = new Date(match.startTimestamp * 1000);
    const dateStr = startDate.toLocaleDateString('cs-CZ', {
        day: '2-digit',
        month: '2-digit',
        year: 'numeric'
    });
    const startTimeStr = startDate.toLocaleTimeString('cs-CZ', {
        hour: '2-digit',
        minute: '2-digit'
    });

    let matchTimeRange = `${dateStr} ${startTimeStr}`;

    // Add end time if available
    if (match.time?.currentPeriodStartTimestamp) {
        const endDate = new Date(match.time.currentPeriodStartTimestamp * 1000);
        const endTimeStr = endDate.toLocaleTimeString('cs-CZ', {
            hour: '2-digit',
            minute: '2-digit'
        });
        matchTimeRange += `-${endTimeStr}`;
    }

    // Keep separate strings for debug info
    const startTimeStrFull = `${dateStr} ${startTimeStr}`;
    const endTimeStr = match.time?.currentPeriodStartTimestamp
        ? new Date(match.time.currentPeriodStartTimestamp * 1000).toLocaleTimeString('cs-CZ', {
            hour: '2-digit',
            minute: '2-digit'
        })
        : 'N/A';

    // Debug information
    const debugInfo = `
        <div class="debug-info">
            <h4>Debug informace:</h4>
            <ul>
                <li><strong>Domácí tým:</strong> ${match.homeTeam.name} (ID: ${match.homeTeam.id})</li>
                <li><strong>Hostující tým:</strong> ${match.awayTeam.name} (ID: ${match.awayTeam.id})</li>
                <li><strong>Je Sparta doma?</strong> ${isHome ? 'Ano' : 'Ne'}</li>
                <li><strong>Čas začátku:</strong> ${startTimeStrFull}</li>
                <li><strong>Čas konce:</strong> ${endTimeStr}</li>
                <li><strong>Název stadionu z API:</strong> "${venueName}" ${venueName ? '' : '(prázdné!)'}</li>
                <li><strong>Venue objekt:</strong> ${JSON.stringify(match.venue, null, 2) || 'undefined'}</li>
                <li><strong>Rozpoznáno jako Letná?</strong> ${isAtLetna ? 'Ano' : 'Ne'}</li>
                <li><strong>Stav zápasu:</strong> ${match.status?.type || 'neznámý'}</li>
                <li><strong>Skóre:</strong> ${match.homeScore?.display || '?'} - ${match.awayScore?.display || '?'}</li>
            </ul>
        </div>
    `;

    if (isAtLetna) {
        matchInfoEl.innerHTML = `
            <div class="yes-match">
                <div class="emoji">🎉</div>
                <h3>Ano! Sparta dnes hraje na Letné!</h3>
                <div class="match-details">
                    <div class="teams">
                        <div class="team">
                            <img src="https://api.sofascore.app/api/v1/team/${match.homeTeam.id}/image" alt="${match.homeTeam.name}">
                            <span>${match.homeTeam.name}</span>
                        </div>
                        <div class="vs">VS</div>
                        <div class="team">
                            <img src="https://api.sofascore.app/api/v1/team/${match.awayTeam.id}/image" alt="${match.awayTeam.name}">
                            <span>${match.awayTeam.name}</span>
                        </div>
                    </div>
                    <div class="match-time">
                        <strong>Čas:</strong> ${matchTimeRange}
                    </div>
                    ${venueName ? `<div class="match-venue"><strong>Stadion:</strong> ${venueName}</div>` : ''}
                </div>
                ${formatUpcomingMatches(upcomingMatches)}
                ${debugInfo}
            </div>
        `;
    } else {
        const location = isHome ? 'doma (ale ne na Letné)' : 'venku';
        matchInfoEl.innerHTML = `
            <div class="no-match">
                <div class="emoji">${isHome ? '🏟️' : '✈️'}</div>
                <h3>Ne, dnes Sparta nehraje na Letné</h3>
                <p>Sparta dnes hraje <strong>${location}</strong> proti týmu ${opponent.name}</p>
                <div class="match-details">
                    <div class="match-time">
                        <strong>Čas:</strong> ${matchTimeRange}
                    </div>
                    ${venueName && isHome ? `<div class="match-venue"><strong>Stadion:</strong> ${venueName}</div>` : ''}
                </div>
                ${formatUpcomingMatches(upcomingMatches)}
                ${debugInfo}
            </div>
        `;
    }
}

// Initialize app
document.addEventListener('DOMContentLoaded', () => {
    checkTodayMatch();
});
