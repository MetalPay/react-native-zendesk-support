export interface Config {
  appId: string;
  clientId: string;
  zendeskUrl: string;
}

export enum HelpCenterGroupType {
  DEFAULT = 0,
  SECTION = 1,
  CATEGORY = 2,
}

interface NewTicketOptions {
  subject?: string;
  tags?: string[];
}

export interface HelpCenterOptions extends NewTicketOptions {
  hideContactSupport?: boolean;
  groupType?: HelpCenterGroupType;
  groupIds?: number[];
}
