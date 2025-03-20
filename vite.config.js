import { defineConfig } from 'vite';
import laravel from 'laravel-vite-plugin';

export default defineConfig({
    plugins: [
        laravel({
            input: ['resources/css/app.css', 'resources/js/app.js'],
            refresh: true,
        }),
    ],
       server: {
           host: '0.0.0.0', // Écoute toutes les IPs
           port: 5173, // Par défaut, changez si nécessaire
           strictPort: true,
           hmr: {
               host: '192.168.10.22', // Remplacez par votre IP locale
           }
       }
});
