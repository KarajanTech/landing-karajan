/**
 * Centralised site data — metadata, navigation, and the structured content used
 * across sections. Keeping strings here keeps the page i18n-ready: a future ES/EN
 * split only needs a parallel object, not a component rewrite.
 *
 * Prose paragraphs live inline in their sections for readability; the repeated,
 * list-shaped content (nav, capabilities, domains) is centralised here.
 */

export const site = {
  name: "Karajan",
  wordmark: "KARAJAN",
  /** One honest line of positioning. */
  tagline:
    "The vendor-neutral orchestration and decision layer for heterogeneous autonomous systems.",
  /** Real contact inbox. */
  contactEmail: "contact@karajan.io",
  /** Canonical production origin (mirrors astro.config `site`). */
  url: "https://karajan.io",
  /** BCP-47 tag; British English matches the copy. Drives <html lang> + og:locale. */
  locale: "en-GB",
} as const;

export const nav: { label: string; href: string }[] = [
  { label: "Layer", href: "#layer" },
  { label: "Architecture", href: "#architecture" },
  { label: "Domains", href: "#domains" },
  { label: "Briefing", href: "#briefing" },
];

export const seo = {
  title: "Karajan — The conductor for autonomous systems",
  description:
    "The vendor-neutral orchestration and decision layer that turns fragmented fleets of drones, robots, and sensors into one explainable, human-supervised network.",
  ogImage: "/og.png",
  ogImageAlt:
    "Karajan — one neutral layer conducting heterogeneous autonomous systems into a single mission.",
} as const;

export type Capability = {
  index: string;
  label: string;
  title: string;
  body: string;
};

export const capabilities: Capability[] = [
  {
    index: "01",
    label: "NEUTRALITY",
    title: "Vendor-neutral by principle",
    body: "Orchestrate any platform, any vendor, any standard. Open, STANAG-aligned interfaces. No lock-in to the hardware you happen to own.",
  },
  {
    index: "02",
    label: "ACCOUNTABILITY",
    title: "Explainable & supervised",
    body: "Every decision is legible and accountable. Governed autonomy, not a black box. A human stays on the loop — supervising, able to intervene.",
  },
  {
    index: "03",
    label: "RESILIENCE",
    title: "Built for DDIL",
    body: "Resilient where bandwidth and connectivity fail — Denied, Degraded, Intermittent, Limited. Edge-first; degrades gracefully.",
  },
  {
    index: "04",
    label: "COORDINATION",
    title: "Mission-level coordination",
    body: "From single-asset tasking to multi-domain choreography across air, ground, sea, and sensor — one intent, coordinated action.",
  },
];

export type Domain = {
  index: string;
  name: string;
  blurb: string;
  status: "now" | "roadmap";
};

export const domains: Domain[] = [
  {
    index: "01",
    name: "Defence",
    blurb: "Sovereign, explainable C2 for multi-vendor unmanned systems.",
    status: "now",
  },
  {
    index: "02",
    name: "Critical infrastructure & energy",
    blurb: "Coordinated monitoring and response across distributed assets.",
    status: "roadmap",
  },
  {
    index: "03",
    name: "Ports & maritime",
    blurb: "Surface, sub-surface, and shore systems under one picture.",
    status: "roadmap",
  },
  {
    index: "04",
    name: "Airspace & UTM",
    blurb: "Deconfliction and tasking for shared, crowded airspace.",
    status: "roadmap",
  },
  {
    index: "05",
    name: "Industrial autonomy",
    blurb: "Mixed fleets conducting work across sites and domains.",
    status: "roadmap",
  },
];
