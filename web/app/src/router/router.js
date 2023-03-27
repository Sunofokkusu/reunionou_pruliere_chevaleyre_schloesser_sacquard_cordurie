import { createRouter, createWebHistory } from 'vue-router';
import NotFound from "@/components/NotFound";
import HomePage from "@/components/HomePage";
import SignIn from "@/components/SignIn";

const routes = [
    { name: 'NotFound', path: '/:pathMatch(.*)*', component: NotFound },
    { name: 'HomePage', path: '/', component: HomePage },
    { name: 'signIn', path: '/signin', component: SignIn },
];

const router = createRouter({
    history: createWebHistory(),
    routes
});

export default router;