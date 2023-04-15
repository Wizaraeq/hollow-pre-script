--誇大化
function c101201065.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101201065,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_BATTLE_START)
	e1:SetCountLimit(1,101201065+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c101201065.acttg)
	e1:SetOperation(c101201065.actop)
	c:RegisterEffect(e1)
end
function c101201065.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local dc=Duel.GetAttackTarget()
	if chk==0 then return dc~=nil end
	local ac=Duel.GetAttacker()
	local b1=ac:IsAttackPos() and ac:IsCanChangePosition()
	local b2=dc:IsAbleToHand()
	local b3=true
	if chk==0 then return b1 or b2 or b3 end
	local off=0
	local ops={}
	local opval={}
	off=1
	if b1 then
		ops[off]=aux.Stringid(101201065,1)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(101201065,2)
		opval[off-1]=2
		off=off+1
	end
	if b3 then
		ops[off]=aux.Stringid(101201065,3)
		opval[off-1]=3
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local sel=opval[op]
	e:SetLabel(sel)
	if sel==1 then
		e:SetCategory(CATEGORY_POSITION)
		Duel.SetOperationInfo(0,CATEGORY_POSITION,ac,1,0,0)
	elseif sel==2 then
		e:SetCategory(CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,dc,1,0,0)
	elseif sel==3 then
		e:SetCategory(CATEGORY_DESTROY)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,Group.FromCards(ac,dc),2,0,0)
	end
	Duel.SetTargetParam(op)
end
function c101201065.actop(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	local ac=Duel.GetAttacker()
	local dc=Duel.GetAttackTarget()
	if op==1 then
		--Change the attacking monster to Defense Position
		if ac:IsAttackPos() and ac:IsRelateToBattle() then
			Duel.ChangePosition(ac,POS_FACEUP_DEFENSE)
		end
	elseif op==2 then
		--Return the attack target to the hand
		if dc and dc:IsRelateToBattle() then
			Duel.SendtoHand(dc,nil,REASON_EFFECT)
		end
	elseif op==3 then
		--Destroy both battling monsters
		local g=Group.FromCards(ac,dc):Filter(Card.IsRelateToBattle,nil)
		if #g~=2 then return end
		Duel.Destroy(g,REASON_EFFECT)
	end
end