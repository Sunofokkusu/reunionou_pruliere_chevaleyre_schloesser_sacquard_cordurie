import { createRouter, createWebHistory } from 'vue-router';
import NotFound from "@/components/NotFound";
import HomePage from "@/components/HomePage";
import SignIn from "@/components/SignIn";
import SignUp from "@/components/SignUp";
import EventPage from "@/components/EventPage";

const routes = [
    { name: 'NotFound', path: '/:pathMatch(.*)*', component: NotFound },
    { name: 'HomePage', path: '/', component: HomePage },
    { name: 'Event', path: '/event/:event_token', component: EventPage },
    { name: 'signIn', path: '/signin', component: SignIn },
    { name: 'signUp', path: '/signup', component: SignUp },
];

const router = createRouter({
    history: createWebHistory(),
    routes
});

export default router;