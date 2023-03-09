node {
	stage ('Checkout') {
		checkout scm
	}
        stage ('Automated test') {
        
        echo "Copy test from repo to molgenis home on Hyperchicken"
        sh "sudo scp test/test_pipeline.sh portal+hyperchicken:/home/umcg-molgenis/test_pipeline_DNA.sh"
        
        echo "Login to Hyperchicken"
	    
	sh '''
            sudo ssh -tt portal+hyperchicken 'exec bash -l << 'ENDSSH'
	    	echo "Starting automated test"
		bash /home/umcg-molgenis/test_pipeline_DNA.sh '''+env.CHANGE_ID+'''
ENDSSH'
        '''	
	}
}
