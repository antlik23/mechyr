import type { ComponentProps } from 'svelte';
import type { UserRole } from '$lib/components/user/types';
import { derived } from 'svelte/store';
import { localizeRoute } from '$lib/i18n';
import { route } from '$lib/ROUTES';
import * as m from '$paraglide/messages';
import { persistedUser } from '$lib/components/user/data';
import type Icon from '$lib/components/wrappers/Icon.svelte';
import {
  HouseIcon,
  FileIcon,
  ChartLineIcon,
  AppWindowIcon,
  BriefcaseMedicalIcon,
  FolderPlusIcon,
  HomeIcon,
  FileDownIcon,
} from 'lucide-svelte';

type MenuLink = {
  icon: ComponentProps<Icon>['icon'];
  text: string;
  link: string;
};

type MenuLinkWithRoles = MenuLink & { roles: UserRole[] };

// TODO: use "currentUser"
export const menuLinks = derived(persistedUser, (userData) => {
  if (!Array.isArray(userData?.user.roles)) return [];

  const { roles } = userData.user;
  const isAdmin = roles.some((role) => role === 'admin');

  const links: MenuLinkWithRoles[] = [
    {
      icon: HouseIcon,
      text: m.homePage(),
      link: localizeRoute(route('/dashboard')),
      roles: ['patient'],
    },
    {
      icon: FileIcon,
      text: m.qualityOfLifeForms(),
      link: localizeRoute(route('/questionnaires')),
      roles: ['patient'],
    },
    {
      icon: FolderPlusIcon,
      text: m.anamnesticForm(),
      link: localizeRoute(route('/anamnestic')),
      roles: ['patient'],
    },
    {
      icon: ChartLineIcon,
      text: m.voidingDiary(),
      link: localizeRoute(route('/voiding-diary')),
      roles: ['patient'],
    },
    {
      icon: AppWindowIcon,
      text: m.entries(),
      link: localizeRoute(route('/entries')),
      roles: ['patient'],
    },
    {
      icon: BriefcaseMedicalIcon,
      text: isAdmin ? m.doctorsList() : m.doctorSelection(),
      link: localizeRoute(route('/doctors')),
      roles: ['admin', 'patient'],
    },
    {
      icon: HomeIcon,
      text: m.patientsList(),
      link: localizeRoute(route('/patients/approved')),
      roles: ['admin', 'doctor'],
    },
    {
      icon: FileIcon,
      text: m.requestOfSharing(),
      link: localizeRoute(route('/patients/to-be-approved')),
      roles: ['doctor'],
    },
    {
      icon: FileDownIcon,
      text: m.exportOfData(),
      link: localizeRoute(route('/export')),
      roles: ['admin'],
    },
  ];

  // Filter links based on user roles.
  return links
    .filter((link) => roles.some((role) => link.roles.includes(role)))
    .map(({ icon, link, text }) => {
      return { icon, link, text } satisfies MenuLink;
    });
});
