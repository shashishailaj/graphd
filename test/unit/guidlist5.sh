# Copyright 2015 Google Inc. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#!/bin/bash

B=`basename $0 .sh`
cd `dirname $0`
source ./rungraphd

rm -rf $D
rungraphd -d${D} -bty <<-'EOF'
	write (value="a")
	write (value="b"  guid=00000012400034568000000000000000)
	write (value="c")
	write (value=null guid=00000012400034568000000000000002)
	read id="b" (value=(null "b")
		     	newest>=0
			guid~=00000012400034568000000000000000 result=((value)))
	read id="b" (guid=(00000012400034568000000000000001
				 00000012400034568000000000000002
				 00000012400034568000000000000003)
		     	newest>=0
			guid~=00000012400034568000000000000000 result=((value)))
	read id="b" (guid!=(00000012400034568000000000000003
				 00000012400034568000000000000002
				 00000012400034568000000000000000)
		     	newest>=0
			guid~=00000012400034568000000000000000 result=((value)))
	read id="abc" (guid~=(00000012400034568000000000000000 00000012400034568000000000000002)
		     	guid!=00000012400034568000000000000003
		     	newest>=0
			result=((value)))
	EOF
rm -rf $D
