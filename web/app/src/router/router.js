import { createRouter, createWebHistory } from 'vue-router';
import NotFound from "@/components/NotFound";
import HomePage from "@/components/HomePage";

const routes = [
    { name: 'NotFound', path: '/:pathMatch(.*)*', component: NotFound },
    { name: 'HomePage', path: '/', component: HomePage },
];

const router = createRouter({
    history: createWebHistory(),
    routes
});

export default router;