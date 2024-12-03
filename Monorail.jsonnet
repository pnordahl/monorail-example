
local paths = {
  // Target paths
  rust: "rust",
  rust_crate1: self.rust + "/crate1",
  rust_crate2: self.rust + "/crate2",
  rust_crate3: self.rust + "/crate3",
  proto: "proto",
  go: "go",
  go_project1: self.go + "/project1",
  go_project2: self.go + "/project2",
  cpp_hello: "c++/hello",

  // Other paths
  rust_cmd: self.rust + "/monorail/cmd",
  rust_cmd_member_test: self.rust_cmd + "/member-test.sh",
};


local commands(cmd_paths) = 
  {
    definitions: {
      [x[0]] : {path: x[1]} for x in cmd_paths
    }
  };

local rust_crate_commands = commands([
  ["test", paths.rust_cmd_member_test],
]);

// Define uses
local rust_crate_uses = [
  paths.proto,
  paths.rust_cmd_member_test
];

// Define sequences
local sequences = {
  dev: [
    "lint",
    "build",
    "test"
  ]
};

{
  source: {
    path: std.thisFile,
  },
  targets: [
    {
      path: paths.rust
    },
    {
      path: paths.rust_crate1,
      uses: rust_crate_uses,
      commands: rust_crate_commands,
      ignores: ["rust/crate1/Cargo.toml"]
    },
    {
      path: paths.rust_crate2,
      uses: rust_crate_uses,
      commands: rust_crate_commands
    },
    {
      path: paths.rust_crate3,
      uses: rust_crate_uses,
      commands: rust_crate_commands
    },
    {
      path: paths.proto
    },
    {
      path: paths.go,
      uses: [paths.proto]
    },
    {
      path: paths.go_project1,
      uses: [paths.proto]
    },
    {
      path: paths.go_project2,
      uses: [paths.proto]
    },
    {
      path: paths.cpp_hello,
      uses: [paths.proto]
    },
  ],
  sequences: sequences
}
