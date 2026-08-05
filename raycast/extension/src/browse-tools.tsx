import {
  Action,
  ActionPanel,
  Icon,
  List,
  getPreferenceValues,
} from "@raycast/api";
import { useExec } from "@raycast/utils";
import { homedir } from "os";
import { join } from "path";
import { useState } from "react";
import { commandFor, search, Tool } from "./search";

function expandTilde(path: string): string {
  return path.startsWith("~") ? join(homedir(), path.slice(1)) : path;
}

function detailMarkdown(tool: Tool): string {
  const heading =
    tool.alias && tool.alias !== tool.name
      ? `${tool.name} (${tool.alias})`
      : tool.name;
  return `# ${heading}\n\n${tool.description}`;
}

function toolItem(tool: Tool) {
  return (
    <List.Item
      key={`${tool.section}/${tool.name}`}
      title={tool.name}
      subtitle={tool.alias && tool.alias !== tool.name ? tool.alias : undefined}
      detail={<List.Item.Detail markdown={detailMarkdown(tool)} />}
      actions={
        <ActionPanel>
          <Action.Paste title="Paste Command" content={commandFor(tool)} />
          <Action.CopyToClipboard
            title="Copy Command"
            content={commandFor(tool)}
          />
          <Action.OpenInBrowser
            title="Open Homebrew Page"
            url={`https://formulae.brew.sh/formula/${tool.name}`}
          />
        </ActionPanel>
      }
    />
  );
}

export default function Command() {
  const { repoPath } = getPreferenceValues<{ repoPath?: string }>();
  const repo = expandTilde(repoPath?.trim() || "~/config/dotfiles");
  const [query, setQuery] = useState("");

  const { isLoading, data, error } = useExec(
    join(repo, "linked", "bin", "dotctl-tools"),
    ["--json"],
    {
      env: { ...process.env, DOTFILES_DIR: repo },
      parseOutput: ({ stdout }) => JSON.parse(stdout) as Tool[],
    },
  );

  if (error) {
    return (
      <List>
        <List.EmptyView
          icon={Icon.Warning}
          title="Could not read TOOLS.md"
          description={`${error.message}\n\nSet the dotfiles repo path in this command's preferences (currently ${repo}).`}
        />
      </List>
    );
  }

  const tools = data ?? [];
  const trimmed = query.trim();
  const matches = trimmed ? search(trimmed, tools) : [];

  return (
    <List
      isLoading={isLoading}
      isShowingDetail
      filtering={false}
      onSearchTextChange={setQuery}
      searchBarPlaceholder="Search by name, alias, or what it replaces (try “top”)"
    >
      {trimmed ? (
        <List.Section
          title={`${matches.length} match${matches.length === 1 ? "" : "es"}`}
        >
          {matches.map(toolItem)}
        </List.Section>
      ) : (
        [...new Set(tools.map((tool) => tool.section))].map((section) => (
          <List.Section key={section} title={section}>
            {tools.filter((tool) => tool.section === section).map(toolItem)}
          </List.Section>
        ))
      )}
      <List.EmptyView
        icon={Icon.MagnifyingGlass}
        title="No tool matches that"
      />
    </List>
  );
}
