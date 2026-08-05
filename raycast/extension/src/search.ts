export type Tool = {
  name: string;
  alias: string;
  section: string;
  description: string;
  aka: string;
};

// " word word " so a leading-space probe tests the start of a word.
function norm(value: string): string {
  return ` ${value
    .toLowerCase()
    .replace(/[^a-z0-9@.+]+/g, " ")
    .trim()} `;
}

// What you would type to run it: bottom is btm, ripgrep is rg.
export function commandFor(tool: Tool): string {
  return tool.alias || tool.name;
}

// Mirrors the bands in dotctl-tools --search. Raycast's own filtering is
// fuzzy, so a query of "top" would also accept a scattered t..o..p and match
// half the list; this matches word starts only, which is why "desktop" and
// "Start/stop" stay out of the results for "top".
function band(term: string, tool: Tool): number {
  const name = norm(tool.name);
  const alias = norm(tool.alias);
  const aka = norm(tool.aka);
  const description = norm(tool.description);

  if (name.includes(` ${term} `)) return 0;
  if (alias.includes(` ${term} `) || aka.includes(` ${term} `)) return 1;
  if (
    name.includes(` ${term}`) ||
    alias.includes(` ${term}`) ||
    aka.includes(` ${term}`)
  )
    return 2;
  if (description.includes(` ${term}`)) return 3;
  return -1;
}

// Every term has to match; the weakest band it lands in wins.
export function rank(query: string, tool: Tool): number {
  const terms = query.toLowerCase().split(/\s+/).filter(Boolean);
  let worst = 0;
  for (const term of terms) {
    const result = band(term, tool);
    if (result < 0) return -1;
    worst = Math.max(worst, result);
  }
  return worst;
}

// Byte order on the command, matching `LC_ALL=C sort` in dotctl-tools.
function byCommand(a: Tool, b: Tool): number {
  const left = commandFor(a);
  const right = commandFor(b);
  return left < right ? -1 : left > right ? 1 : 0;
}

export function search(query: string, tools: Tool[]): Tool[] {
  return tools
    .map((tool) => ({ tool, score: rank(query, tool) }))
    .filter(({ score }) => score >= 0)
    .sort((a, b) => a.score - b.score || byCommand(a.tool, b.tool))
    .map(({ tool }) => tool);
}
