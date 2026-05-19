// API Base URL
const API_BASE = '/api/v1';

// API Helper Functions
const API = {
    getToken() {
        return localStorage.getItem('auth_token');
    },

    setToken(token) {
        if (token) {
            localStorage.setItem('auth_token', token);
        } else {
            localStorage.removeItem('auth_token');
        }
    },

    async request(endpoint, options = {}) {
        const headers = {
            'Content-Type': 'application/json',
            ...options.headers
        };

        const token = this.getToken();
        if (token) {
            headers['Authorization'] = token;
        }

        try {
            const response = await fetch(`${API_BASE}${endpoint}`, {
                ...options,
                headers
            });

            // For logout, we don't expect JSON response
            if (options.method === 'DELETE' && endpoint === '/auth/logout') {
                if (response.ok) {
                    return { success: true };
                } else {
                    throw new Error('Logout failed');
                }
            }

            const data = await response.json();
            
            if (!response.ok) {
                throw new Error(data.error || data.errors?.join(', ') || 'Request failed');
            }

            // Capture token from response headers
            const authHeader = response.headers.get('Authorization');
            if (authHeader) {
                this.setToken(authHeader);
            }

            return data;
        } catch (error) {
            console.error('API Error:', error);
            throw error;
        }
    },

    get(endpoint) {
        return this.request(endpoint, { method: 'GET' });
    },

    post(endpoint, body) {
        return this.request(endpoint, {
            method: 'POST',
            body: JSON.stringify(body)
        });
    },

    patch(endpoint, body) {
        return this.request(endpoint, {
            method: 'PATCH',
            body: JSON.stringify(body)
        });
    },

    delete(endpoint) {
        return this.request(endpoint, { method: 'DELETE' });
    }
};

// Auth API Functions
window.AuthAPI = {
    async register(userData) {
        return API.post('/auth/register', { user: userData });
    },

    async login(credentials) {
        const response = await fetch(`${API_BASE}/auth/login`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ user: credentials })
        });
        
        const data = await response.json();
        
        if (!response.ok) {
            throw new Error(data.error || 'Login failed');
        }
        
        // Get token from response headers
        const token = response.headers.get('Authorization');
        if (token) {
            API.setToken(token);
        }
        
        return data;
    },

    async logout() {
        try {
            const result = await API.delete('/auth/logout');
            // Always clear local token regardless of server response
            API.setToken(null);
            return result;
        } catch (error) {
            // Even if server fails, clear local token
            API.setToken(null);
            throw error;
        }
    }
};

// Children API Functions
window.ChildrenAPI = {
    async getAll(params = {}) {
        const queryString = new URLSearchParams(params).toString();
        return API.get(`/children${queryString ? '?' + queryString : ''}`);
    },

    async getById(id) {
        return API.get(`/children/${id}`);
    },

    async create(childData) {
        return API.post('/children', { child: childData });
    },

    async update(id, childData) {
        return API.patch(`/children/${id}`, { child: childData });
    },

    async delete(id) {
        return API.delete(`/children/${id}`);
    }
};

console.log('API initialized successfully');
